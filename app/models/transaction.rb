class Transaction < ApplicationRecord
  belongs_to :invoice

  def self.total_revenue(start, ending)
    Transaction.joins(invoice: :invoice_items)
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .where('transactions.created_at > ?', start)
    .where('transactions.created_at < ?', ending)
    .select('SUM(invoice_items.quantity * invoice_items.unit_price) as revenue')

    # Transaction.joins(invoice: :invoice_items).where(transactions: {result: 'success'}, invoices: {status: 'shipped'}).where('transactions.created_at > ?', "1970-01-01 00:00:00").where('transactions.created_at < ?', "2100-01-01 00:00:00").select('SUM(invoice_items.quantity * invoice_items.unit_price) as revenue')
  end
end
