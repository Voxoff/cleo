# frozen_string_literal: true

class Coin
  @@all = []
  attr_accessor :quantity
  attr_reader :denomination

  def initialize(denomination:, quantity:)
    validate_denomination(denomination)

    @denomination = denomination
    @quantity = quantity
    @@all << self
  end

  def validate_denomination(denomination)
    unless self.class.denominations.include?(denomination)
      raise ArgumentError, 'Coins must be an acceptable denomination'
    end
  end

  def self.all
    @@all
  end

  def self.reload
    all.each { |coin| coin.quantity = 0 }
  end

  def insert
    self.quantity += 1
  end

  def release
    self.quantity -= 1 if self.quantity > 0
  end

  def self.find_by_denomination(denom)
    all.detect { |coin| coin.denomination == denom }
  end

  def self.denominations
    [1, 2, 5, 10, 20, 50, 100, 200]
  end

  def self.calculate_change(change_to_return)
    coin_hash = Hash.new(0)
    all.sort_by(&:denomination).reverse_each do |coin|
      denom = coin.denomination
      while denom <= change_to_return && coin.quantity > 0
        coin_hash[denom] += 1
        coin.release
        change_to_return -= denom
      end
    end
    coin_hash
  end
end
