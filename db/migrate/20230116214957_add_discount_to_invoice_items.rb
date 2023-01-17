class AddDiscountToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_items, :discount, :float, default: 0.0
  end
end
