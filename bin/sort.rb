# frozen_string_literal: true

# sort collection of filtered array with cars
class Sort
  attr_reader :result_of_search

  def initialize(rules, result_of_search)
    @rules = rules
    @result_of_search = result_of_search
    sort_by_prise_and_date_added
  end

  def sort_by_prise_and_date_added
    @result_of_search.sort_by { |car| Date.strptime(car['date_added'], '%d/%m/%y') }.reverse
    if @rules['order_by'] == 'price'
      @result_of_search.sort_by! do |car|
        car['price']
      end
    else
      @result_of_search.sort_by! { |car| Date.strptime(car['date_added'], '%d/%m/%y') }
    end
    @rules['order_direction'] == 'asc' ? @result_of_search : @result_of_search.reverse!
  end
end
