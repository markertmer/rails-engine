require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'finds by name' do
    before :each do
      merchant = create(:merchant)
      @item_1 = create(:item, merchant: merchant, name: "Smart Pants")
      @item_2 = create(:item, merchant: merchant, name: "A Bunch of Ants")
      @item_3 = create(:item, merchant: merchant, name: "Mustard")
    end

    it 'finds exact matches' do
      expected = [@item_1]
      expect(Item.find_by_name("Smart Pants")).to eq(expected)
    end

    it 'finds partial matches' do
      expected = [@item_3]
      expect(Item.find_by_name("star")).to eq(expected)
    end

    it 'finds multiple matches & sorts alphabetically' do
      expected = [@item_2, @item_1]
      expect(Item.find_by_name("ants")).to eq(expected)
    end

    it 'sad path: no matches' do
      expected = []
      expect(Item.find_by_name("bliff")).to eq(expected)
    end
  end

  describe 'finds by price' do
    before :each do
      merchant = create(:merchant)
      @item_1 = create(:item, merchant: merchant, unit_price: 54.99)
      @item_2 = create(:item, merchant: merchant, unit_price: 4.20)
      @item_3 = create(:item, merchant: merchant, unit_price: 13.50)
    end

    it 'finds prices larger than a min' do
      price_hash = {min_price: "10.00"}
      expected = [@item_3, @item_1]
      expect(Item.find_by_price(price_hash)).to eq(expected)
    end

    it 'finds prices smaller than a max' do
      price_hash = {max_price: "20.00"}
      expected = [@item_2, @item_3]
      expect(Item.find_by_price(price_hash)).to eq(expected)
    end

    it 'finds prices within a range' do
      price_hash = {min_price: "5.00", max_price: "50.00"}
      expected = [@item_3]
      expect(Item.find_by_price(price_hash)).to eq(expected)
    end

    it 'edge case: prices equal to min and max' do
      price_hash = {min_price: "4.20", max_price: "54.99"}
      expected = [@item_2, @item_3, @item_1]
      expect(Item.find_by_price(price_hash)).to eq(expected)
    end

    it 'sad path: no price large enough' do
      price_hash = {min_price: "999.99"}
      expected = []
      expect(Item.find_by_price(price_hash)).to eq(expected)
    end

    it 'sad path: no price small enough' do
      price_hash = {max_price: "00.99"}
      expected = []
      expect(Item.find_by_price(price_hash)).to eq(expected)
    end
  end
end
