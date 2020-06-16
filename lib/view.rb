# frozen_string_literal: true

class View
  def initialize
    system('clear')
    puts 'Welcome to the Nuka-Cola vending machine.'
    puts "=========================================\n\n"
  end

  def display_items(items)
    puts "\n"
    items.each.with_index(1) do |item, button_index|
      puts "#{button_index}.  #{item.name} - #{to_money(item.price)}"
    end
  end

  def instructions
    puts "\nPlease enter the code displayed to buy a drink. " \
          'Or type 999, if you would like to change the list of items in the machine.'
  end

  def get_input
    print '>> '
    gets.chomp
  end

  def try_again
    print "I didn't quite get that. "
  end

  def get_coin(item, change)
    puts "You've chosen #{item.name}. That'll be #{to_money(item.price)}"
    puts "Current amount entered: #{to_money(change)}"
    get_input.to_i
  end

  def print_acceptable_denominations
    # Ideally, would use the to_sentence method from ActiveSupport, Rails.
    puts "This machine accepts the following denominations: #{Coin.denominations.join(', ')}"
  end

  def dispense(change_hash, item)
    puts 'Change: '
    if change_hash.empty?
      puts 'No change'
    else
      puts(change_hash.map { |denomination, quantity| "#{quantity} x #{to_money(denomination)}" })
    end
    puts "\n*** Serving #{item.name} ***"
  end

  def to_money(money)
    "#{money}p"
  end

  def choose_reload
    puts 'Press 0 to alter items or press 1 to alter the change.'
    get_input.to_i
  end

  def new_item
    puts 'Please enter the name of the new item: '
    name = get_input
    puts "And it's price: "
    price = get_input.to_i
    { name: name, price: price }
  end

  def another?(class_name)
    puts "Would you like to add another #{class_name}? (Y/N)"
    get_input.downcase.include?('y')
  end

  def new_change
    print_acceptable_denominations
    puts 'Please enter one of the above denominations: '
    denomination = get_input.to_i
    puts 'Please enter the number of coins: '
    quantity = get_input.to_i
    { denomination: denomination, quantity: quantity }
  end
end
