# Manage / retrieve promotions
class Promotion
  attr_reader :rules

  def initialize(promotion_name)
    @rules = get_rules_for(promotion_name)
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
