class Api::V1::Merchants::SearchController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find_by_name(params[:name]))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find_by_name(params[:name]).first)
  end
end
