require 'spec_helper'
require_relative '../../lib/promotion'
require_relative '../factories/item'

describe Promotion do
  it 'get promotion rules' do
    # setup
    promo = Promotion.new('over_60_and_lavender_heart')

    # verify
    expect(promo.rules).to be_kind_of(Hash)
  end

  it 'raise error when trying to get an invalid promotion' do
    # verify
    expect { Promotion.new('invalid_promotion') }
      .to raise_error('Invalid promotion!')
  end

  context 'promo is over_60_and_lavender_heart' do
    it 'has 10% discount for total over 60' do
      # setup
      promo = Promotion.new('over_60_and_lavender_heart')

      min_total = promo.rules['on_total']['min_amount']
      discount = promo.rules['on_total']['discount']
      discount_type = promo.rules['on_total']['discount_type']

      # verify
      expect(min_total).to eq 60
      expect(discount).to eq 10
      expect(discount_type).to eq 'percent'
    end

    it 'has fixed discounted price 2 or more lavender heart' do
      # setup
      promo = Promotion.new('over_60_and_lavender_heart')

      min_quantity = promo.rules['on_item']['001']['min_quantity']
      discount_type = promo.rules['on_item']['001']['discount_type']
      promo_price = promo.rules['on_item']['001']['promo_price']

      # verify
      expect(min_quantity).to eq 2
      expect(discount_type).to eq 'promo_price'
      expect(promo_price).to eq 8.5
    end

    it 'return discounted price for given item if matches the rules' do
      # setup
      promo = Promotion.new('over_60_and_lavender_heart')
      item1 = FactoryGirl.build(:item, :item1)
      quantity = 3

      # exercise
      unit_price = promo.discounted_price(item1[:code], item1[:price], quantity)

      # verify
      expect(unit_price.to_s('F')).to eq '8.5'
    end

    it 'return discounted total for given item if matches the rules' do
      # setup
      promo = Promotion.new('over_60_and_lavender_heart')
      total = BigDecimal.new(65)

      # exercise
      unit_price = promo.discounted_total(total)

      # verify
      expect(unit_price.to_s('F')).to eq '58.5'
    end
  end
end
