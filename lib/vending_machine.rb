# frozen_string_literal: true

class VendingMachine
  attr_reader :view
  attr_accessor :money_inserted

  def initialize(items:, change:)
    raise ArgumentError, 'A vending machine must have items hash' unless items.is_a?(Hash)
    raise ArgumentError, 'A vending machine must have change hash' unless change.is_a?(Hash)

    items.each { |name, price| Item.new(name: name, price: price) }
    change.each { |denom, quantity| Coin.new(denomination: denom, quantity: quantity) }

    @view = View.new
    @online = false
    @money_inserted = 0
  end

  def turn_on
    @online = true
    while @online
      display_items
      view.instructions
      action = view.get_input
      route_action(action)
    end
  end

  def route_action(action)
    if action.to_i.between?(1, Item.all.size)
      select(action.to_i)
    elsif action.to_i == 999
      reload
    elsif action.casecmp('exit').zero?
      exit
    else
      view.try_again
    end
  end

  private

  def exit
    @online = false
  end

  def display_items
    view.display_items(Item.all)
  end

  def select(input)
    selected_item = Item.all[input - 1]
    wait_for_coin(selected_item)
    change_to_return = Coin.calculate_change(money_inserted - selected_item.price)
    view.dispense(change_to_return, selected_item)
    self.money_inserted = 0
  end

  def wait_for_coin(item)
    while money_inserted < item.price
      coin = view.get_coin(item, money_inserted)
      accept_or_reject_coin(coin)
    end
  end

  def accept_or_reject_coin(coin_integer)
    if (@coin = Coin.find_by_denomination(coin_integer))
      self.money_inserted += @coin.denomination
      @coin.insert
    else
      view.try_again
      view.print_acceptable_denominations
    end
  end

  def reload
    if view.choose_reload.zero?
      Item.reload
      Item.new(view.new_item)
      Item.new(view.new_item) while view.another?('item')
    else
      Coin.reload
      Coin.new(view.new_change)
      Coin.new(view.new_change) while view.another?('coin')
    end
  end
end
