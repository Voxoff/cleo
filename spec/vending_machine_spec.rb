# frozen_string_literal: true

require_relative '../lib/vending_machine'
require_relative 'support'

RSpec.describe VendingMachine do
  # Careful, a let named ':change' overrides Rspec 'change' built-in matcher

  let(:coin_change) { { 1 => 2, 2 => 1, 5 => 5, 10 => 10, 20 => 3, 50 => 2, 100 => 10, 200 => 1 } }
  let(:items) { { 'Nuka-Cola': 90, 'Sunset Sarsparilla': 200, 'Sierra Madre': 45, 'Bawls Guarana': 110 } }
  subject { VendingMachine.new(change: coin_change, items: items) }

  before do
    silence_output
    allow_any_instance_of(Kernel).to receive(:system).with('clear').and_return(false)
  end

  describe '#route_action' do
    it 'routes to reload on 999' do
      expect(subject).to receive(:reload)
      subject.route_action('999')
    end

    it 'routes to exit' do
      expect(subject).to receive(:exit)
      subject.route_action('exit')
    end

    it 'routes to select' do
      expect(subject).to receive(:select)
      subject.route_action('1')
    end
  end

  describe '#turn_on' do
    before do
      allow(subject.view).to receive(:get_input).and_return('exit')
    end

    it 'prints items and instructions, asks for input and routes that input' do
      expect(subject.view).to receive(:display_items)
      expect(subject.view).to receive(:instructions)
      expect(subject.view).to receive(:get_input)
      expect(subject)
        .to receive(:route_action)
        .with('exit')
        .and_call_original

      subject.turn_on
    end
  end

  describe '#display_items' do
    it 'hands off to the view with a list of items' do
      expect(subject.view)
        .to receive(:display_items)
        .with(array_including(instance_of(Item)))

      subject.send(:display_items)
    end
  end

  describe '#select' do
    let(:item) { Item.all.first }

    it 'takes change and returns appropriate change and item' do
      allow(subject).to receive(:money_inserted).and_return(100)
      appropriate_change = 100 - item.price

      expect(subject).to receive(:wait_for_coin).with(item)
      expect(Coin).to receive(:calculate_change).with(appropriate_change).and_return(10)
      expect(subject.view).to receive(:dispense).with(10, item)

      subject.send(:select, 1)
    end
  end

  describe '#wait_for_coin' do
    let(:item) { Item.all.first }

    it 'asks for coins and accepts or rejects those coins' do
      expect(subject.view).to receive(:get_coin).with(item, 0).and_return(100)
      expect(subject).to receive(:accept_or_reject_coin).with(100).and_call_original

      subject.send(:wait_for_coin, item)
    end
  end

  describe '#reload' do
    context 'user chooses to reload items' do
      let(:choice) { 0 }
      it 'calls view to ask for input' do
        expect(subject.view).to receive(:choose_reload).and_return(choice)
        expect(subject.view).to receive(:new_item).and_return({ name: 'Test_item', price: 10 })
        expect(subject.view).to receive(:another?).and_return(false)

        subject.send(:reload)
      end
    end

    context 'user chooses to reload coins' do
      let(:choice) { 1 }
      it 'calls view to ask for input' do
        expect(subject.view).to receive(:choose_reload).and_return(choice)
        expect(subject.view).to receive(:new_change).and_return({ denomination: 10, quantity: 10 })
        expect(subject.view).to receive(:another?).and_return(false)

        subject.send(:reload)
      end
    end
  end

  describe '#accept_or_reject_coin' do
    context 'A valid coin' do
      let(:coin_int) { 1 }

      it 'checks denomination of coin and accepts the coin' do
        expect { subject.send(:accept_or_reject_coin, coin_int) }
          .to change { subject.money_inserted }
          .by(1)
      end
    end

    context 'An invalid coin' do
      let(:coin_int) { 99 }

      it 'checks denomination of coin, rejects it and prints appropriately' do
        expect(subject.view).to receive(:print_acceptable_denominations)

        expect { subject.send(:accept_or_reject_coin, coin_int) }
          .not_to change { subject.money_inserted }
      end
    end
  end

  describe 'buying a Nuka-Cola' do
    before do
      Item.reload
      Coin.class_variable_set(:@@all, [])
    end

    let(:item) { Item.all.first }

    it 'asks for item, then coins and prints correct change and item' do
      expect(subject.view).to receive(:get_input).and_return(1, 'exit')
      expect(subject.view).to receive(:get_coin).with(item, 0).and_return(100)
      expect(subject.view).to receive(:dispense).with({ 10 => 1 }, item)
      subject.turn_on
    end
  end
end
