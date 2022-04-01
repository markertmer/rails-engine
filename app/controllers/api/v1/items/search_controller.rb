class Api::V1::Items::SearchController < ApplicationController
  def index
   # if !params[:name] || params[:name] == ""
   #   render json: { data: { error: 'ERROR', message: "search query 'name' does not exist"} },
   #   status: :bad_request
   # else
   #   items = item_search
   #   if items.empty?
   #     render json: { data: { error: 'ERROR', message: 'No records match the supplied keyword'} },
   #     status: :not_found
   #   else
   #     items = item_search.first if items.count == 1
   #     render json: ItemSerializer.new(items)
   #   end
   # end
    items = item_search
    items = item_search.first if items.count == 1
    render json: ItemSerializer.new(items)
  end

  def show
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
