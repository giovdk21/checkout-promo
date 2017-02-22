# Shopping basket / checkout manager
class Basket
  attr_reader :items_count

  def initialize
    @items = []
    @items_count = 0
  end

  # Add an item to the basket, incrementing its quantity if already present
  def scan(item)
    found_item = find_by_code(item.code)
    if found_item
      found_item[:quantity] += 1
    else
      @items << { data: item, quantity: 1 }
    end

    @items_count += 1
  end

  # Find an item in the basket by its product code
  def find_by_code(code)
    @items.detect { |item| item[:data].code == code }
  end

  # Return the total to be paid, and apply the promotion
  # if promotion_name is provided
  def total(promotion_name = false)
    total = 0

    @promo = Promotion.new(promotion_name) if promotion_name

    @items.each do |basket_item|
      total = sum_item(basket_item, total)
    end

    total
  end

  private

  # Sum the given item to the total based on quantity and, if give, promotion
  def sum_item(basket_item, total)
    unit_price = basket_item[:data].price * basket_item[:quantity]
    total + unit_price
  end
end
