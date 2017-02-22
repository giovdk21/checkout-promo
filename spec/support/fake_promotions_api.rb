# Mocks the answer from the API endpoint
# I didn't use Rack to avoid having an extra dependency just for this
# but at the same time I wanted to keep this dynamic and more scalable
class FakePromotionsApi
  def call(path, query)
    case path
    when '/v1/promotion'
      # assuming we don't have other parameters other than "id"
      promotion_name = query[3..-1] # get the value after id=...
      load_promotion(promotion_name)
    else
      return nil # (do nothing)
    end
  end

  private

  def load_promotion(promotion_name)
    json_file = File.dirname(__FILE__) + '/fixtures/promotions.json'
    json = File.open(json_file, 'rb').read
    promotions = JSON.parse(json)

    if promotions[promotion_name]
      promotions[promotion_name].to_json
    else
      'error'
    end
  end
end
