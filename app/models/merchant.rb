class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true

  def self.find_by_name(keyword)
    where("name ILIKE ?", "%#{keyword}%").order(:name)
  end
end
