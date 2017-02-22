require 'rspec'
require 'factory_girl'
require 'webmock/rspec'
require 'support/fake_promotions_api'

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, %r{api\.localhost/v1/}).to_return(
      status: 200,
      body: lambda do |request|
        fake_promo_api = FakePromotionsApi.new
        fake_promo_api.call request.uri.path.to_s, request.uri.query.to_s
      end
    )
  end
end
