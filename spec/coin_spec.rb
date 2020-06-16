# frozen_string_literal: true

require_relative '../lib/coin'

RSpec.describe Coin do
  before(:each) do
    Coin.class_variable_set(:@@all, [])
  end

  subject { Coin.new(denomination: 100, quantity: 10) }

  describe '#validate_denomination' do
    it 'will raise an argument error if invalid denomination is given' do
      expect { Coin.new(denomination: 99, quantity: 10) }.to raise_error(ArgumentError)
    end
  end

  describe '#insert' do
    it 'increases quantity by 1' do
      expect { subject.insert }.to change { subject.quantity }.from(10).to(11)
    end
  end

  describe '#release' do
    it 'decreases quantity by 1' do
      expect { subject.release }.to change { subject.quantity }.from(10).to(9)
    end

    context 'with only one coin' do
      let(:coin) { Coin.new(denomination: 10, quantity: 1)}
      it 'does not have negative quantity' do
        expect { coin.release }.to change { coin.quantity }.from(1).to(0)
        expect { coin.release }.to_not change { coin.quantity }
      end
    end
  end

  describe '.all' do
    it 'stores and returns all instances in an array' do
      coin = Coin.new(denomination: 1, quantity: 10)
      expect(Coin.all).to eq([coin])

      another_coin = Coin.new(denomination: 2, quantity: 10)
      expect(Coin.all).to contain_exactly(coin, another_coin)
    end
  end

  describe '.reload' do
    it 'sets the quantity of coins to 0 on reload' do
      Coin.new(denomination: 1, quantity: 10)
      Coin.new(denomination: 100, quantity: 10)
      Coin.reload
      expect(Coin.all.map(&:quantity)).to eq([0, 0])
    end
  end

  describe '.denominations' do
    it 'returns the acceptable denominations' do
      expect(Coin.denominations).to eq([1, 2, 5, 10, 20, 50, 100, 200])
    end
  end

  describe '.calculate_change' do
    context 'with enough change' do
      it 'calculates change to return to user using available coins only' do
        Coin.new(denomination: 1, quantity: 10)
        Coin.new(denomination: 5, quantity: 10)
        Coin.new(denomination: 10, quantity: 10)
        Coin.new(denomination: 50, quantity: 10)
        Coin.new(denomination: 100, quantity: 10)
        change = Coin.calculate_change(105)
        expect(change).to eq({ 100 => 1, 5 => 1 })
      end
    end

    context 'with insufficient change' do
      it 'returns as much change as possible' do
        Coin.new(denomination: 5, quantity: 3)
        Coin.new(denomination: 50, quantity: 1)
        change = Coin.calculate_change(90)
        expect(change).to eq({ 50 => 1, 5 => 3})
      end
    end
  end
end
