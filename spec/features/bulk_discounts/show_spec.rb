require 'rails_helper'

RSpec.describe 'bulk discount show' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Self Aware')

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant1)
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant1)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merchant1)
    @bulk_discount_4 = create(:bulk_discount, merchant: @merchant2)
    @bulk_discount_5 = create(:bulk_discount, merchant: @merchant2)

    visit merchant_bulk_discount_path(@merchant1, @bulk_discount_1)
  end

  describe 'As a merchant' do
    describe 'When I visit my bulk discount show page' do
      it 'shows the bulk discount\'s quantity threshold and percentage discount' do
        expect(page).to have_content("Id: #{@bulk_discount_1.id}")
        expect(page).to have_content("Discount: #{@bulk_discount_1.discount}%")
        expect(page).to have_content("Threshold: #{@bulk_discount_1.threshold} Items")
      end
    end
  end
end