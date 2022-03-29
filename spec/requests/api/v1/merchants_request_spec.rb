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

      expect(merchant[:attributes]).to have_key(:id)
      expect(merchant[:attributes][:id]).to be_a(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'responds with all the attributes of one merchant' do

  end
end
