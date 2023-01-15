class BulkDiscountsController < ApplicationController
  before_action :find_discount_and_merchant, only: [:show, :update]
  before_action :find_merchant, only: [:index]

  def index
    @discounts = BulkDiscount.find_by(merchant_id: @merchant)
  end

  def find_discount_and_merchant
    @invoice = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end