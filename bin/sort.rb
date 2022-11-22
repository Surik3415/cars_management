
class Sort

    attr_reader :result_of_search

    def initialize rules, result_of_search
        @rules = rules
        @result_of_search = result_of_search
        sort_by_prise_and_date_added
    end


    def sort_by_prise_and_date_added
        @result_of_search.sort_by {|car| Date.strptime(car["date_added"], '%d/%m/%y')}.reverse 
        @rules["order_by"] == "price"  ? @result_of_search.sort_by! {|car| car["price"]} : @result_of_search.sort_by! {|car| Date.strptime(car["date_added"], '%d/%m/%y')}
        @rules["order_direction"] == "asc" ?@result_of_search : @result_of_search.reverse!
    end

end

