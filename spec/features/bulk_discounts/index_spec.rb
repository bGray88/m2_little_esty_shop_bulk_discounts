require 'rails_helper'

RSpec.describe 'merchant discount index' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Self Aware')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @bulk_discount_1 = create(:bulk_discount, merchant: @merchant1)
    @bulk_discount_2 = create(:bulk_discount, merchant: @merchant1)
    @bulk_discount_3 = create(:bulk_discount, merchant: @merchant1)
    @bulk_discount_4 = create(:bulk_discount, merchant: @merchant2)
    @bulk_discount_5 = create(:bulk_discount, merchant: @merchant2)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  describe 'As a merchant' do
    describe 'to to their bulk discount index' do
      it 'Lists all their discounts: percentage discount & quantity threshold' do
        expect(page).to_not have_content("Id: #{@bulk_discount_4.id}")

        within("#merchant-discount-#{@bulk_discount_1.id}") do
          expect(page).to have_content("Id: #{@bulk_discount_1.id}")
          expect(page).to have_content("Discount: #{@bulk_discount_1.discount}%")
          expect(page).to have_content("Threshold: #{@bulk_discount_1.threshold} Items")
        end
        within("#merchant-discount-#{@bulk_discount_2.id}") do
          expect(page).to have_content("Id: #{@bulk_discount_2.id}")
          expect(page).to have_content("Discount: #{@bulk_discount_2.discount}%")
          expect(page).to have_content("Threshold: #{@bulk_discount_2.threshold} Items")
        end
        within("#merchant-discount-#{@bulk_discount_3.id}") do
          expect(page).to have_content("Id: #{@bulk_discount_3.id}")
          expect(page).to have_content("Discount: #{@bulk_discount_3.discount}%")
          expect(page).to have_content("Threshold: #{@bulk_discount_3.threshold} Items")
        end
      end

      it 'Lists links to discount show pages' do
        within("#merchant-discount-#{@bulk_discount_1.id}") do
          click_on("#{@bulk_discount_1.id}")
        end

        expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
      end

      describe 'Shows a link to create a new discount, when clicked' do
        describe 'taken new page where I see a form to add a new bulk discount and when form is filled with valid data' do
          it 'redirects back to their bulk discount index shows new bulk discount listed' do
            click_on("Create Bulk Discount")

            expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))

            fill_in("discount", with: 75)
            fill_in("threshold", with: 100)
            click_on("Submit")

            expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
            expect(page).to have_content("Discount: 75")
            expect(page).to have_content("Threshold: 100")

            visit merchant_bulk_discounts_path(@merchant1)
            click_on("Create Bulk Discount")

            expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
            click_on("Submit")

            expect(page).to have_content("Error")
          end
        end
      end

      describe 'next to each bulk discount I see a link to delete it' do
        it 'when clicked, redirects back to bulk discount index, discount is gone' do
          within("#merchant-discount-#{@bulk_discount_1.id}") do
            click_on("Delete")
          end

          expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

          expect(page).to_not have_content("Id: #{@bulk_discount_1.id}")
        end
      end
    end
  end
end
