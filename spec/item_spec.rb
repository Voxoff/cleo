# frozen_string_literal: true

require_relative '../lib/item.rb'

RSpec.describe Item do
  before(:each) do
    Item.class_variable_set(:@@all, [])
  end

  describe '.all' do
    it 'returns all instances in an array' do
      expect(Item.all).to be_empty
      item = Item.new(name: 'Herzwesten beer', price: 100)
      expect(Item.all).to contain_exactly(item)

      another_item = Item.new(name: 'Vesper', price: 200)
      expect(Item.all).to contain_exactly(item, another_item)
    end
  end

  describe '.reload' do
    it 'empties @@all class variable array' do
      expect(Item.all).to be_empty
      item = Item.new(name: 'Blue milk', price: 100)
      expect(Item.all).to contain_exactly(item)

      Item.reload
      expect(Item.all).to be_empty
    end
  end
end
