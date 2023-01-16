class BulkDiscountsController < ApplicationController
  before_action :find_discount_and_merchant, only: [:show, :update]
  before_action :find_merchant, only: [:index]

  def index
    @bulk_discounts = BulkDiscount.where(merchant_id: @merchant)
  end

  def show
  end

  def new
  end

  def create
    bulk_discount = BulkDiscount.new(bulk_discount_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path
    else
      flash[:notice] = "Error: #{bulk_discount.errors.full_messages}"
      render :new
    end
  end

  def find_discount_and_merchant
    @invoice = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  private
  def bulk_discount_params
    params.permit(:discount, :threshold, :merchant_id)
  end
end