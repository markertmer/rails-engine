require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'gets all merchants' do
    create_list(:merchant, 13)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants[:data].count).to eq(13)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant[:type]).to eq("merchant")

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'gets one merchant' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/#{merchant_1.id}"

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

  it 'gets all items of one merchant' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)

    merchant_2 = create(:merchant)
    item_4 = create(:item, merchant: merchant_2)

    get "/api/v1/merchants/#{merchant_1.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item[:type]).to eq("item")

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:name]).to_not eq(item_4.name)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:description]).to_not eq(item_4.description)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:unit_price]).to_not eq(item_4.unit_price)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant_1.id)
      expect(item[:attributes][:merchant_id]).to_not eq(merchant_2.id)
      expect(item[:attributes][:merchant_id]).to_not eq(item_4.merchant_id)
    end
  end

  describe 'merchant search' do
    before :each do
      @merchant_1 = create(:merchant, name: "Turing Merch")
      @merchant_2 = create(:merchant, name: "Ring World")
      @merchant_3 = create(:merchant, name: "Cloud Zone")
    end

    it 'finds a single merchant, exact match' do
      get '/api/v1/merchants/find?name=Turing%20Merch'

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data].count).to eq(3)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:id].to_i).to eq(@merchant_1.id)
      expect(merchant[:data][:id].to_i).to_not eq(@merchant_2.id)
      expect(merchant[:data][:id].to_i).to_not eq(@merchant_3.id)

      expect(merchant[:data][:type]).to eq("merchant")

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
      expect(merchant[:data][:attributes][:name]).to eq(@merchant_1.name)
      expect(merchant[:data][:attributes][:name]).to_not eq(@merchant_2.name)
      expect(merchant[:data][:attributes][:name]).to_not eq(@merchant_3.name)
    end

    it 'finds a single merchant, partial match' do
      get '/api/v1/merchants/find?name=oud'

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data].count).to eq(3)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:id].to_i).to eq(@merchant_3.id)
      expect(merchant[:data][:id].to_i).to_not eq(@merchant_2.id)
      expect(merchant[:data][:id].to_i).to_not eq(@merchant_1.id)

      expect(merchant[:data][:type]).to eq("merchant")

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
      expect(merchant[:data][:attributes][:name]).to eq(@merchant_3.name)
      expect(merchant[:data][:attributes][:name]).to_not eq(@merchant_2.name)
      expect(merchant[:data][:attributes][:name]).to_not eq(@merchant_1.name)
    end

    it 'finds multiple matches, sorted alphabetically' do
      get '/api/v1/merchants/find_all?name=ring'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(2)

      expect(merchants[:data][0]).to have_key(:id)
      expect(merchants[:data][0][:id]).to be_a(String)
      expect(merchants[:data][0][:id].to_i).to eq(@merchant_2.id)
      expect(merchants[:data][0][:id].to_i).to_not eq(@merchant_3.id)
      expect(merchants[:data][0][:id].to_i).to_not eq(@merchant_1.id)
      expect(merchants[:data][0][:type]).to eq("merchant")
      expect(merchants[:data][0][:attributes]).to have_key(:name)
      expect(merchants[:data][0][:attributes][:name]).to be_a(String)
      expect(merchants[:data][0][:attributes][:name]).to eq(@merchant_2.name)
      expect(merchants[:data][0][:attributes][:name]).to_not eq(@merchant_3.name)
      expect(merchants[:data][0][:attributes][:name]).to_not eq(@merchant_1.name)

      expect(merchants[:data][1]).to have_key(:id)
      expect(merchants[:data][1][:id]).to be_a(String)
      expect(merchants[:data][1][:id].to_i).to eq(@merchant_1.id)
      expect(merchants[:data][1][:id].to_i).to_not eq(@merchant_3.id)
      expect(merchants[:data][1][:id].to_i).to_not eq(@merchant_2.id)
      expect(merchants[:data][1][:type]).to eq("merchant")
      expect(merchants[:data][1][:attributes]).to have_key(:name)
      expect(merchants[:data][1][:attributes][:name]).to be_a(String)
      expect(merchants[:data][1][:attributes][:name]).to eq(@merchant_1.name)
      expect(merchants[:data][1][:attributes][:name]).to_not eq(@merchant_3.name)
      expect(merchants[:data][1][:attributes][:name]).to_not eq(@merchant_2.name)
    end

    it 'sad path: no matches for find' do
      get '/api/v1/merchants/find?name=xyz'

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to be nil
    end

    it 'sad path: no matches for find_all' do
      get '/api/v1/merchants/find_all?name=xyz'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].empty?).to be true
    end
  end
end
