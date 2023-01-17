class BulkDiscountsController < ApplicationController
  before_action :find_discount_and_merchant, only: [:edit, :show, :update, :destroy]
  before_action :find_merchant, only: [:new, :create, :index]

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

  def edit
  end

  def update
    @bulk_discount.update(bulk_discount_params)

    redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
  end

  def destroy
    @bulk_discount.destroy

    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def find_discount_and_merchant
    @bulk_discount = BulkDiscount.find(params[:id])
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