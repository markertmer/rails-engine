require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'finds by name' do
    before :each do
      @merchant_1 = create(:merchant, name: "Turing Merch")
      @merchant_2 = create(:merchant, name: "Ring World")
      @merchant_3 = create(:merchant, name: "Cloud Zone")
    end

    it 'finds exact matches' do
      expected = [@merchant_1]
      expect(Merchant.find_by_name("Turing Merch")).to eq(expected)
    end

    it 'finds partial matches' do
      expected = [@merchant_3]
      expect(Merchant.find_by_name("cloud")).to eq(expected)
    end

    it 'finds multiple matches & sorts alphabetically' do
      expected = [@merchant_2, @merchant_1]
      expect(Merchant.find_by_name("ring")).to eq(expected)
    end

    it 'sad path: no matches' do
      expected = []
      expect(Merchant.find_by_name("bliff")).to eq(expected)
    end
  end
end
