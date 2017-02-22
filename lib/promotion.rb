# Manage / retrieve promotions
class Promotion
  # Get the rule set for the required promotion calling the
  # promotion API endpoint
  def get_rules_for(promotion_name)
    response = Net::HTTP.get(
      'api.localhost', "/v1/promotion?id=#{promotion_name}"
    )
    JSON.parse(response)
  end
end
