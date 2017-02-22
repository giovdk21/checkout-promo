require 'spec_helper'
require_relative '../../lib/promotion'

describe Promotion do
  it 'get promotion rules' do
    # setup
    promo = Promotion.new

    # exercise
    promo_rules = promo.get_rules_for('over_60_and_lavender_heart')

    # verify
    expect(promo_rules).to be_kind_of(Hash)
  end

  it 'raise error when trying to get an invalid promotion' do
    # setup
    promo = Promotion.new

    # verify
    expect { promo.get_rules_for('invalid_promotion') }
      .to raise_error('Invalid promotion!')
  end

  context 'promo is over_60_and_lavender_heart' do
    it 'has 10% discount for total over 60' do
      promo = Promotion.new
      promo_rules = promo.get_rules_for('over_60_and_lavender_heart')

      min_total = promo_rules['on_total']['min_amount']
      discount = promo_rules['on_total']['discount']
      discount_type = promo_rules['on_total']['discount_type']

      expect(min_total).to eq 60
      expect(discount).to eq 10
      expect(discount_type).to eq 'percent'
    end

    it 'has fixed discounted price 2 or more lavender heart' do
      promo = Promotion.new
      promo_rules = promo.get_rules_for('over_60_and_lavender_heart')

      min_quantity = promo_rules['on_item']['001']['min_quantity']
      discount_type = promo_rules['on_item']['001']['discount_type']
      promo_price = promo_rules['on_item']['001']['promo_price']

      expect(min_quantity).to eq 2
      expect(discount_type).to eq 'promo_price'
      expect(promo_price).to eq 8.5
    end
  end
end
