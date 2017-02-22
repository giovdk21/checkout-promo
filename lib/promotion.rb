# Manage / retrieve promotions
class Promotion
  attr_reader :rules

  def initialize(promotion_name)
    @rules = get_rules_for(promotion_name)
  end

  def discounted_price(item_code, price, quantity)
    item_promo_rules = @rules['on_item'][item_code]

    # Check if the minimum quantity requirement is met
    return price unless item_promo_rules && quantity >= item_promo_rules['min_quantity']

    case item_promo_rules['discount_type']
    when 'promo_price'
      BigDecimal.new(item_promo_rules['promo_price'].to_s)
    else
      price # return the same price (no discount)
    end
  end

  def discounted_total(total)
    case @rules['on_total']['discount_type']
    when 'percent'
      discount = (total / 100 * @rules['on_total']['discount'])
      (total - discount)
    when 'value'
      (total - @rules['on_total']['discount'])
    else
      total
    end
  end

  private

  # Get the rule set for the required promotion calling the
  # promotion API endpoint
  def get_rules_for(promotion_name)
    response = Net::HTTP.get(
      'api.localhost', "/v1/promotion?id=#{promotion_name}"
    )
    if response != 'error'
      JSON.parse(response)
    else
      fail 'Invalid promotion!'
    end
  end
end
