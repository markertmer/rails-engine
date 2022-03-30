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
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)

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

  it 'creates an item' do
    merchant_1 = create(:merchant)

    item_params = ({
      name: 'Smart Pants',
      description: 'Experience seamless pants management with the touch of a button, all from the SmartPants app!',
      unit_price: 125.98,
      merchant_id: merchant_1.id
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to be_successful

    created_item = Item.last

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data].count).to eq(3)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:id].to_i).to eq(created_item.id)

    expect(item[:data][:type]).to eq("item")

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes][:name]).to eq(created_item.name)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes][:description]).to eq(created_item.description)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    expect(item[:data][:attributes][:unit_price]).to eq(created_item.unit_price)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
    expect(item[:data][:attributes][:merchant_id]).to eq(created_item.merchant_id)
  end

  it 'updates an item' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    id = item.id
    original_name = item.name
    original_description = item.description
    original_unit_price = item.unit_price
    original_merchant_id = item.merchant_id

    item_params = { name: "Smart Pants" }
    headers = {"CONTENT_TYPE" => "application/json"}

    put "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response).to be_successful

    updated_item = Item.find_by(id: id)

    expect(updated_item.name).to_not eq(original_name)
    expect(updated_item.name).to eq("Smart Pants")

    expect(updated_item.id).to eq(id)

    expect(updated_item.description).to eq(original_description)
    expect(updated_item.unit_price).to eq(original_unit_price)
    expect(updated_item.merchant_id).to eq(original_merchant_id)

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data].count).to eq(3)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:id].to_i).to eq(updated_item.id)

    expect(item[:data][:type]).to eq("item")

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes][:name]).to eq(updated_item.name)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes][:description]).to eq(updated_item.description)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    expect(item[:data][:attributes][:unit_price]).to eq(updated_item.unit_price)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
    expect(item[:data][:attributes][:merchant_id]).to eq(updated_item.merchant_id)
  end

  it 'destroys an item' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(response.status).to be(204)

    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)

    # item = JSON.parse(response.body, symbolize_names: true)
    # expect(item[:data]).to be(nil)
  end

  it 'gets the merchant of an item' do
    merchant_1 = create(:merchant)
    item = create(:item, merchant: merchant_1)
    merchant_2 = create(:merchant)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data].count).to eq(3)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:id].to_i).to eq(merchant_1.id)
    expect(merchant[:data][:id].to_i).to_not eq(merchant_2.id)

    expect(merchant[:data][:type]).to eq("merchant")

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data][:attributes][:name]).to eq(merchant_1.name)
    expect(merchant[:data][:attributes][:name]).to_not eq(merchant_2.name)
  end
end
