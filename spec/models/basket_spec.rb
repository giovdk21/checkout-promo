require 'spec_helper'
require_relative '../../lib/basket'
require_relative '../factories/item'

describe Basket do
  it 'is possible to add/scan an item' do
    item1 = FactoryGirl.build(:item, :item1)

    subject.scan item1

    items_count = subject.items_count
    expect(items_count).to eq 1
  end

  it 'finds an item in the basket by its code' do
    item1 = FactoryGirl.build(:item, :item1)

    subject.scan item1
    basket_item = subject.find_by_code(item1.code)

    expect(basket_item[:data]).to eq item1
  end

  it 'increase quantity if the same item is added multiple times' do
    item1 = FactoryGirl.build(:item, :item1)

    subject.scan item1
    subject.scan item1
    basket_item = subject.find_by_code(item1.code)
    items_count = subject.items_count

    expect(items_count).to eq 2
    expect(basket_item[:quantity]).to eq 2
  end

  context 'no promotions' do
    it 'calculates the correct total' do
      item1 = FactoryGirl.build(:item, :item1)
      item2 = FactoryGirl.build(:item, :item2)
      subject.scan item1
      subject.scan item1
      subject.scan item2

      total = subject.total

      expect(total.to_s('F')).to eq('63.5')
    end

    it 'handles decimals correctly' do
      item3 = FactoryGirl.build(:item, :item3)
      subject.scan item3
      subject.scan item3
      subject.scan item3

      total = subject.total

      expect(total.to_s('F')).to eq('59.85')
    end
  end

  context 'over_60_and_lavender_heart promotion' do
    it 'does not apply discount on total if less than or equal min_amount' do
      item1 = FactoryGirl.build(:item, :item1)
      item2 = FactoryGirl.build(:item, :item2)
      subject.scan item1
      subject.scan item2

      total = subject.total('over_60_and_lavender_heart')

      expect(total.to_s('F')).to eq('54.25')
    end

    # Basket: 001,002,003
    it 'apply discount on the total if more than min_amount' do
      item1 = FactoryGirl.build(:item, :item1)
      item2 = FactoryGirl.build(:item, :item2)
      item3 = FactoryGirl.build(:item, :item3)
      subject.scan item1
      subject.scan item2
      subject.scan item3

      total = subject.total('over_60_and_lavender_heart')

      expect(total.to_s('F')).to eq('66.78')
    end

    it 'does not apply discount on the item if quantity is not enough' do
      item1 = FactoryGirl.build(:item, :item1)
      item3 = FactoryGirl.build(:item, :item3)
      subject.scan item1
      subject.scan item3

      total = subject.total('over_60_and_lavender_heart')

      expect(total.to_s('F')).to eq('29.2')
    end

    # Basket: 001,003,001
    it 'apply discount on the item if quantity is enough' do
      item1 = FactoryGirl.build(:item, :item1)
      item3 = FactoryGirl.build(:item, :item3)
      subject.scan item1
      subject.scan item3
      subject.scan item1

      total = subject.total('over_60_and_lavender_heart')

      expect(total.to_s('F')).to eq('36.95')
    end

    # Basket: 001,002,001,003
    it 'combines discount on total and items' do
      item1 = FactoryGirl.build(:item, :item1)
      item2 = FactoryGirl.build(:item, :item2)
      item3 = FactoryGirl.build(:item, :item3)
      subject.scan item1
      subject.scan item2
      subject.scan item1
      subject.scan item3

      total = subject.total('over_60_and_lavender_heart')

      expect(total.to_s('F')).to eq('73.76')
    end

    it 'does not apply discount on the item if not meant to' do
      item2 = FactoryGirl.build(:item, :item2, price: BigDecimal.new('25'))
      subject.scan item2
      subject.scan item2

      total = subject.total('over_60_and_lavender_heart')

      expect(total.to_s('F')).to eq('50.0')
    end
  end

  # 5 pounds discount on orders above 80
  # Personalised cufflinks price is 40 pounds if you buy 2 or more
  # Kids T-shirt price is 15 pounds if you buy 3 or more
  context 'over_80_cufflinks_tshirt promotion' do
    it 'apply discount on the total when more than min_amount' do
      item1var = FactoryGirl.build(:item, :item1, price: BigDecimal.new('35'))
      item2 = FactoryGirl.build(:item, :item2)

      subject.scan item1var
      total1 = subject.total('over_80_cufflinks_tshirt')
      subject.scan item2
      total2 = subject.total('over_80_cufflinks_tshirt')
      subject.scan item1var
      total3 = subject.total('over_80_cufflinks_tshirt')

      expect(total1.to_s('F')).to eq('35.0')
      expect(total2.to_s('F')).to eq('80.0')
      expect(total3.to_s('F')).to eq('110.0') # 5 pounds discount applied
    end

    it 'apply discount on the item if quantity is enough' do
      item3 = FactoryGirl.build(:item, :item3)

      subject.scan item3
      subject.scan item3
      total1 = subject.total('over_80_cufflinks_tshirt')
      subject.scan item3
      total2 = subject.total('over_80_cufflinks_tshirt')

      expect(total1.to_s('F')).to eq('39.9')
      expect(total2.to_s('F')).to eq('45.0') # price reduced to 15 pounds
    end

    it 'combines discount on total and items' do
      item1 = FactoryGirl.build(:item, :item1)
      item2 = FactoryGirl.build(:item, :item2)
      item3 = FactoryGirl.build(:item, :item3)

      subject.scan item1
      subject.scan item1
      subject.scan item2
      subject.scan item2
      subject.scan item3
      total = subject.total('over_80_cufflinks_tshirt')

      expect(total.to_s('F')).to eq('113.45')
    end
  end
end
