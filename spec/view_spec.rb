# frozen_string_literal: true

require_relative '../lib/view'
require_relative '../lib/item'
require_relative 'support'

RSpec.describe View do
  subject { View.new }
  let(:item) { Item.new(name: 'Pan-Galactic Gargle Blaster', price: 15) }

  before do
    allow_any_instance_of(Kernel).to receive(:system).with('clear').and_return(false)
  end

  describe '#initialize' do
    it 'prints introduction' do
      intro = capture_stdout { subject }
      expect(intro).to match(/Welcome to the Nuka-Cola vending machine/)
    end

    it 'should clear the terminal' do
      expect_any_instance_of(Kernel).to receive(:system).with 'clear'
      capture_stdout { subject }
    end
  end

  describe '#display_items' do
    let(:second_item) { Item.new(name: 'Victory Gin', price: 25) }
    it 'displays items with index, name and price' do
      output = capture_stdout { subject.display_items([item, second_item]) }
      expect(output).to match /1\.  Pan-Galactic Gargle Blaster - 15p/
      expect(output).to match /2\.  Victory Gin - 25p/
    end
  end

  describe '#instructions' do
    it 'prints instructions' do
      desired_instructions = /Please enter the code displayed to buy a drink. Or type 999, if you would like to change the list of items in the machine/
      printed_instructions = capture_stdout { subject.instructions }
      expect(printed_instructions).to match(desired_instructions)
    end
  end

  describe '#get_input' do
    it 'asks for input' do
      gets_double = double
      allow(gets_double).to receive(:chomp)
      expect_any_instance_of(Kernel).to receive(:gets).and_return(gets_double)

      capture_stdout { subject.get_input }
    end
  end

  describe '#try_again' do
    it 'prints friendly error message' do
      output = capture_stdout { subject.try_again }
      expect(output).to match(/I didn't quite get that/)
    end
  end

  describe '#get_coin' do
    it 'prints item name and cost' do
      expect(subject).to receive(:get_input).and_return('test_string')

      output = capture_stdout { subject.get_coin(item, 5) }
      expect(output).to match(/You've chosen Pan-Galactic Gargle Blaster. That'll be 15/)
      expect(output).to match(/Current amount entered: 5p/)
    end
  end

  describe '#print_acceptable_denominations' do
    it 'prints a list of valid denominations' do
      output = capture_stdout { subject.print_acceptable_denominations }
      expect(output).to match(/This machine accepts the following denominations: 1, 2, 5, 10, 20, 50, 100, 200/)
    end
  end

  describe '#dispense' do
    context 'no change to return' do
      let(:change_hash) { {} }

      it 'prints no change' do
        output = capture_stdout { subject.dispense(change_hash, item) }
        expect(output).to match(/No change/)
      end
    end

    context 'there is change to return' do
      let(:change_hash) { { 100 => 1, 5 => 1 } }
      it 'prints info about the coins being released' do
        output = capture_stdout { subject.dispense(change_hash, item) }
        expect(output).to match(/1 x 100p/)
        expect(output).to match(/1 x 5p/)
      end
    end
  end

  describe '#to_money' do
    before { silence_output }

    it 'adds p to the string for nice formatting' do
      given_money_string = '100'
      formatted_money_string = '100p'
      expect(subject.to_money(given_money_string)).to eq formatted_money_string
    end
  end

  describe '#choose_reload' do
    it 'prints choice and awaits input' do
      expect(subject).to receive(:get_input)

      output = capture_stdout { subject.choose_reload }
      expect(output).to match /Press 0 to alter items or press 1 to alter the change/
    end
  end

  describe '#new_item' do
    it 'asks for item name and price' do
      expect(subject).to receive(:get_input).twice.and_return('test_string')

      output = capture_stdout { subject.new_item }
      expect(output).to match('Please enter the name of the new item')
      expect(output).to match("And it's price:")
    end
  end

  describe '#another?' do
    before { silence_output }

    it 'asks for another reload' do
      expect(subject).to receive(:get_input).and_return('test_string')

      output = capture_stdout { subject.another?('test') }
      expect(output).to match("Would you like to add another test\?")
    end
  end

  describe '#new_change' do
    it 'asks for denominations and coins' do
      expect(subject).to receive(:print_acceptable_denominations)
      expect(subject).to receive(:get_input).twice.and_return('test_string')

      output = capture_stdout { subject.new_change }
      expect(output).to match('Please enter one of the above denominations')
      expect(output).to match('Please enter the number of coins')
    end
  end
end
