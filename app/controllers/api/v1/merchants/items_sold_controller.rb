class Api::V1::Merchants::ItemsSoldController < ApplicationController
  def index
    number = params[:quantity]
    merchants = Merchant.most_items(number)
    render json: ItemsSoldSerializer.new(merchants)
  end
end
