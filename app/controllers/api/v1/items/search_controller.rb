class Api::V1::Items::SearchController < ApplicationController
  def index
    # items = Item.find_by_name(params[:name])
    items = item_search
    render json: ItemSerializer.new(items)
  end

  def show
    # item = Item.find_by_name(params[:name]).first
    item = item_search.first

    render json: ItemSerializer.new(item)
  end

  private

  def item_search
    if (params[:name] &&
      (params[:min_price] || params[:max_price])) ||
      (!params[:name] && !params[:min_price] && !params[:max_price])

      "ERROR!"
    elsif params[:name]
      Item.find_by_name(params[:name])
    elsif params[:min_price] || params[:max_price]
      price_hash = {min_price: params[:min_price], max_price: params[:max_price]}
      Item.find_by_price(price_hash)
    end
  end
end
