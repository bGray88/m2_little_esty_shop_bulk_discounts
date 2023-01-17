class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status,
                        :discount

  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :invoice
  has_many :bulk_discounts, through: :merchants

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def applicable_discount
    self.bulk_discounts
        .select('invoice_items.*, bulk_discounts.*')
        .where("invoice_items.id = #{self.id} AND #{self.quantity} >= bulk_discounts.threshold")
        .order('bulk_discounts.discount desc')
        .limit(1)
        .first
  end

  def update_discount(bulk_discount)
    self.discount = 0
    self.discount = (bulk_discount.discount / 100.00) unless bulk_discount.nil?
    self.save
  end
end
