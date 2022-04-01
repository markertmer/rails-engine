class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    if merchant.nil?
      render json: MerchantSerializer.new(merchant), status: :not_found
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
