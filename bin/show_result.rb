
class Show_result

    attr_reader :show_statistic, :show_requested_car

    def initialize statistic_info, result_of_search

        @statistic_info = statistic_info
        @result_of_search = result_of_search

        show_statistic
        show_requested_car 
        
    end


    def show_statistic
        puts "---------------------------------------\nStatistic: 
        \nTotal Quantity: #{@statistic_info['total_quantity_of_cars']} 
        \nRequests quantity: #{@statistic_info['quantity_of_request']}\n"

    end

    def show_requested_car
        puts "--------------------------------------- \nResults:"
        @result_of_search.each do |car|
            car.each { |key, value| puts "\n#{key}: #{value}" }
            puts "---------------------------------------"
        end
    end
end

