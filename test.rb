# load module to work with yaml files
require 'yaml'

# load module to work with dates
require 'date' 

# create a function to display statistic information
def show_statistic
    puts "---------------------------------------\nStatistic: 
    \nTotal Quantity: #{$heshed_request["total_quantity_of_cars"]} 
    \nRequests quantity: #{$heshed_request["get_quantity_of_request"]}\n"
end

# create a function to display the result on the screen
def show_requested_car 
    puts "--------------------------------------- \nResults:"
    $cars_file.each do |car|
        car.each { |key, value| puts "\n#{key}: #{value}" }
        puts "---------------------------------------"
    end
end



#create hash with request parameter
$request_parameter = {}

# get argument for search request
puts "Please choose make: "
make = gets.capitalize.chomp
$request_parameter[:make] = make

puts "Please choose model: "
model = gets.capitalize.chomp
$request_parameter [:model] = model

puts "Please choose year_from: "
year_from = gets.chomp
$request_parameter[:year_from] = year_from

puts "Please choose year_to: "
year_to = gets.chomp
$request_parameter[:year_to] = year_to

puts "Please choose price_from: "
price_from = gets.chomp
$request_parameter[:price_from] = price_from

puts "Please choose price_to: "
price_to = gets.chomp
$request_parameter[:price_to] = price_to

# load a yaml file + symbolize all keys of hashes
$cars_file = YAML.safe_load_file('cars.yml', symbolize_names: true) 

# creating a function for filtering files 
def filter_arr_with_cars_by_make_and_model(rule)
    skip_by_empty_value = $request_parameter[rule] == ""
    $cars_file.keep_if {|car| car[rule] == $request_parameter[rule] || skip_by_empty_value}
end


filter_arr_with_cars_by_make_and_model(:make)
filter_arr_with_cars_by_make_and_model(:model)


def filter_arr_with_cars_by_year_and_price(rule, parameter_from, parameter_to)

    from = $request_parameter[parameter_from]
    tok = $request_parameter[parameter_to]

    skip_by_empty_from = from == ""
    skip_by_empty_to = tok == ""

    $cars_file.keep_if do |car|
        (car[rule] >= from.to_i || skip_by_empty_from) && (car[rule] <= tok.to_i || skip_by_empty_to)
    end
end


#call a function that filter the array of cars according to the required parameters
#filter by given date of manufacture of the car
filter_arr_with_cars_by_year_and_price(:year, :year_from, :year_to)


#call a function that filter the array of cars according to the required parameters
#filter by the given price range
filter_arr_with_cars_by_year_and_price(:price, :price_from, :price_to)


# defolt sort by date_added. Sort by decline
$cars_file = $cars_file.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}.reverse 


# get order parameter and diraction for sort process
puts ("Please choose sort option (date_added|price): ")
order_by = gets.chomp
$request_parameter[:order_by] = order_by

puts ("Please choose sort direction(desc|asc): ")
order_direction = gets.chomp
$request_parameter[:order_direction] = order_direction


# condition for sort by parametere and diraction
order_by == "price"  ?  $cars_file.sort_by! {|car| car[:price]} :  $cars_file.sort_by! {|car| Date.strptime(car[:date_added], '%d/%m/%y')}

order_direction == "asc" ? $cars_file : $cars_file.reverse!

#call function to show the result of executing the request according to the specified parameters
#show_requested_car 



#open yaml file to sabe body of my requests
$searches = File.open("./searches.yml","a+")



#create class to create a requests
class Request

    #allow to make changes in parameters
    attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :order_by, :order_direction, :get_quantity_of_request

    #initialize constructor function to create a request
    def initialize (make, model, year_from, year_to, price_from, price_to, order_by, order_direction)
        @make = make
        @model = model
        @year_from = year_from
        @year_to = year_to
        @price_from = price_from
        @price_to = price_to
        @order_by = order_by
        @order_direction = order_direction
        @total_quantity_of_cars = 0
        @get_quantity_of_request = 1

        get_quantity_of_cars

    end

    #пубудивись це, бо походу ти це будеш видаляти 
    def get_quantity_of_cars
        
        if $cars_file.length > 0
            @total_quantity_of_cars = $cars_file.length
        end
        return @total_quantity_of_cars
    end

    def incr_same_req 

    end

end

#initialize my request
request_object = Request.new(make, model, year_from, year_to, price_from, price_to, order_by, order_direction)

#create hash from object to save it in yaml file
$heshed_request = {}
request_object.instance_variables.each {|var| $heshed_request[var.to_s.delete("@")] = request_object.instance_variable_get(var) }



#open "searches.yml" with my requests 
log = File.open("searches.yml")
yp = YAML::load_stream(log) {|doc|

    # increament QuantityOfSameReq if same request was finded in yaml file 
    if ($heshed_request.to_a.slice(0,9) & doc.to_a.slice(0,9)) == doc.to_a.slice(0,9)
     $heshed_request["get_quantity_of_request"] += 1

 end  
}

#save request hash in yaml file
$searches.puts YAML.dump($heshed_request)
$searches.close

#puts a Statistic info about total quantity of finded car by last request and
#puts a Statistic info requests quantity with same parameters 


show_statistic
show_requested_car