# frozen_string_literal: true

class Item
  attr_reader :name, :price

  @@all = []

  def initialize(name:, price:)
    @name = name
    @price = price.to_i
    @@all << self
  end

  def self.all
    @@all
  end

  def self.reload
    @@all = []
  end
end
