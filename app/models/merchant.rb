class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  validates :name, presence: true

  def self.find_by_name(keyword)
    where("name ILIKE ?", "%#{keyword}%").order(:name)
  end

  def self.top_merchants_by_revenue(number)
    # Merchant.joins(invoices: { invoice_items: :transactions })
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .group('merchants.id')
    .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .order('total_revenue DESC')
    .limit(number)
    # .order(total_revenue: :descending)
  end

  def self.most_items(number)
    joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .group('merchants.id')
    .select('merchants.*, SUM(invoice_items.quantity) as total_sold')
    .order('total_sold DESC')
    .limit(number)
  end

end
