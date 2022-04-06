class Api::V1::RevenueController < ApplicationController

  def total
    start = format_date(params[:start])
    ending = format_date(params[:end], 1)
    amount = Transaction.total_revenue(start, ending)
    x = render json: RevenueSerializer.format_data(amount[0])
    # x = render json: RevenueSerializer.new(amount[0])
  end

  def format_date(date, advance = 0)
    a = date.split("-")
    d = DateTime.new(a[0].to_i, a[1].to_i, a[2].to_i) + advance
    f = DateTime.parse(d.to_s)
    f.strftime("%Y-%m-%d %H:%M:%S")

    # require 'date'
    # a = date.split("-")
    # binding.pry
    # d = DateTime.new(a[0].to_i, a[1].to_i, a[2].to_i)
    # binding.pry
    # (d + advance).to_s.gsub("T", " ").delete_suffix("+00:00")
    # binding.pry
  end
end
