require 'rails_helper'

RSpec.describe 'Items API' do
  it 'gets all items' do
    merchant_1 = create(:merchant)

    13.times do
      create(:item, merchant: merchant_1)
    end

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(13)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item[:type]).to eq("item")

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it 'gets one item' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1 )
    item_2 = create(:item, merchant: merchant_1 )

    get "/api/v1/items/#{item_1.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data].count).to eq(3)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:id].to_i).to eq(item_1.id)
    expect(item[:data][:id].to_i).to_not eq(item_2.id)

    expect(item[:data][:type]).to eq("item")

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes][:name]).to eq(item_1.name)
    expect(item[:data][:attributes][:name]).to_not eq(item_2.name)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes][:description]).to eq(item_1.description)
    expect(item[:data][:attributes][:description]).to_not eq(item_2.description)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    expect(item[:data][:attributes][:unit_price]).to eq(item_1.unit_price)
    expect(item[:data][:attributes][:unit_price]).to_not eq(item_2.unit_price)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
    expect(item[:data][:attributes][:merchant_id]).to eq(item_1.merchant_id)
  end
end
