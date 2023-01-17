require_relative './holiday.rb'

module Api
  module Date
    class DateService
      def self.date_api_holidays
        Holiday.new.next_three
      end
    end
  end
end
