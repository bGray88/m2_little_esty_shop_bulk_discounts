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

      describe 'shows a link to edit the bulk discount which when clicked a new page opens' do 
        describe 'a form to edit the discount with discounts current attributes are pre-poluated in the form' do
          describe 'when any/all of the information is changed and click submit redirects to the bulk discount\'s show page' do
            it 'shows that the discount\'s attributes have been updated' do
              click_on("Edit")

              expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1))

              expect(page).to have_field('discount', with: @bulk_discount_1.discount)
              expect(page).to have_field('threshold', with: @bulk_discount_1.threshold)

              fill_in('discount', with: 75)

              click_on('Update Bulk Discount')

              expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
              expect(page).to have_field('discount', with: 75)

              click_on("Edit")
              
              fill_in('discount', with: 85)
              fill_in('threshold', with: 100)

              click_on('Update Bulk Discount')

              expect(page).to have_field('discount', with: 85)
              expect(page).to have_field('threshold', with: 100)
            end
          end
        end
      end
    end
  end
end