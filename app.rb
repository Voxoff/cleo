# frozen_string_literal: true

require_relative './lib/item'
require_relative './lib/coin'
require_relative './lib/view'
require_relative './lib/vending_machine'

change = { 1 => 2, 2 => 1, 5 => 5, 10 => 10, 20 => 3, 50 => 2, 100 => 10, 200 => 1 }
items = { 'Nuka-Cola': 90, 'Sunset Sarsparilla': 200, 'Sierra Madre': 45, 'Bawls Guarana': 110 }

machine = VendingMachine.new(items: items, change: change)
machine.turn_on
