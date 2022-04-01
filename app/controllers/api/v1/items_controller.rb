class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: :created
  end

  def update
    item = Item.find(params[:id])
    if item.nil?
      render json: ItemSerializer.new(item), status: :not_found
    elsif item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: ItemSerializer.new(item), status: :bad_request
    end
  end

  def destroy
    Item.destroy(params[:id])
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
