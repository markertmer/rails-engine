class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_by_name(keyword)
    where("name ILIKE ?", "%#{keyword}%").order(:name)
  end

  def self.find_by_price(price_hash)
    floor = 0
    floor = price_hash[:min_price] if price_hash[:min_price]
    ceiling = Float::INFINITY
    ceiling = price_hash[:max_price] if price_hash[:max_price]

    where("unit_price >= ?", "#{floor}")
    .where("unit_price <= ?", "#{ceiling}")
    .order(:unit_price)
  end
end
