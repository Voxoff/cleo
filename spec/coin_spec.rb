# frozen_string_literal: true

require_relative '../lib/coin'

RSpec.describe Coin do
  before(:each) do
    Coin.class_variable_set(:@@all, [])
  end

  subject { Coin.new(denomination: 100, quantity: 10) }

  describe '#initialize' do
    it 'will raise argument error if denomination is not valid' do
      expect { Coin.new(denomination: 99, quantity: 10) }.to raise_error(ArgumentError)
    end
  end

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
    it 'decreaases quantity by 1' do
      expect { subject.release }.to change { subject.quantity }.from(10).to(9)
    end
  end

  describe '.all' do
    it 'stores previous new coins in class variable' do
      subject = Coin.new(denomination: 1, quantity: 10)
      expect(Coin.all).to eq([subject])
    end
  end

  describe '.reload' do
    it 'empties all class variable on reload' do
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
    before { Coin.class_variable_set(:@@all, []) }

    context 'with enough change' do
      it 'calculates change to return to user using available coins only' do
        Coin.new(denomination: 1, quantity: 15)
        Coin.new(denomination: 5, quantity: 15)
        Coin.new(denomination: 10, quantity: 15)
        Coin.new(denomination: 100, quantity: 1)
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
