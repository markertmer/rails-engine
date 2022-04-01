class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchants = Merchant.find_by_name(params[:name])
    render json: MerchantSerializer.new(merchants)
  end

  def show
    if !params[:name] || params[:name] == ""
      render json: { data: { error: 'ERROR', message: "search query 'name' does not exist"} },
      status: :bad_request
    else
      merchant = Merchant.find_by_name(params[:name])
      if merchant.empty?
        render json: { data: { error: 'ERROR', message: 'No records match the supplied keyword'} },
        status: :not_found
      else
        render json: MerchantSerializer.new(merchant.first)
      end
    end
  end
end
