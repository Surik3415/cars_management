# frozen_string_literal: true

# sort collection of filtered array with cars
class Sort
  attr_reader :sorted_result

  def initialize(rules, sorted_result)
    @rules = rules
    @sorted_result = sorted_result
  end

  def call
    sort_by_prise_and_date_added
  end

  def sort_by_prise_and_date_added
    @sorted_result.sort_by { |car| Date.strptime(car['date_added'], '%d/%m/%y') }.reverse
    if @rules['order_by'] == 'price'
      @sorted_result.sort_by! do |car|
        car['price']
      end
    else
      @sorted_result.sort_by! { |car| Date.strptime(car['date_added'], '%d/%m/%y') }
    end
    @rules['order_direction'] == 'asc' ? @sorted_result : @sorted_result.reverse!
  end
end
