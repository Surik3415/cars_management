
# load module to work with yaml files
require 'yaml'

# load module to work with dates
require 'date' 

# create a function to display the result on the screen
def show_requested_car (requested_cars)
    puts "--------------------------------------- \nResults:"
    requested_cars.each do |car|
        car.each { |key, value| puts "#{key}: #{value}" }
        puts "---------------------------------------"
    end
end

#create hash with request parameter
$request_parameter = {}

# get argument for search request
puts "Please choose make: "
$request_parameter[:make] = gets.capitalize.chomp

puts "Please choose model: "
$request_parameter [:model] = gets.capitalize.chomp

puts "Please choose year_from: "
$request_parameter[:year_from] = gets.chomp

puts "Please choose year_to: "
$request_parameter[:year_to] = gets.chomp

puts "Please choose price_from: "
$request_parameter[:price_from] = gets.chomp

puts "Please choose price_to: "
$request_parameter[:price_to] = gets.chomp

# load a yaml file + symbolize all keys of hashes
cars_file = YAML.safe_load_file('cars.yml', symbolize_names: true) 

# creating a function for filtering files 
def filter_arr_with_cars_by_make_and_model(rule, requested_cars)
    skip_by_empty_value = $request_parameter[rule] == ""
    requested_cars.keep_if {|car| car[rule] == $request_parameter[rule] || skip_by_empty_value}
end

make = :make
model = :model

filter_arr_with_cars_by_make_and_model(make, cars_file)
filter_arr_with_cars_by_make_and_model(model, cars_file)


def filter_arr_with_cars_by_year_and_price(rule, parameter_from, parameter_to, requested_cars)

    from = $request_parameter[parameter_from]
    tok = $request_parameter[parameter_to]

    skip_by_empty_from = from == ""
    skip_by_empty_to = tok == ""

    requested_cars.keep_if do |car|
        (car[rule] >= from.to_i || skip_by_empty_from) && (car[rule] <= tok.to_i || skip_by_empty_to)
    end
end

#put the keys in separate variables
year = :year
year_from = :year_from
year_to = :year_to

#call a function that filter the array of cars according to the required parameters
#filter by given date of manufacture of the car
filter_arr_with_cars_by_year_and_price(year, year_from, year_to, cars_file)

#put the keys in separate variables
price = :price
price_from = :price_from
price_to = :price_to

#call a function that filter the array of cars according to the required parameters
#filter by the given price range
filter_arr_with_cars_by_year_and_price(price, price_from, price_to, cars_file)


# defolt sort by date_added. Sort by decline
cars_file = cars_file.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}.reverse 


# get order parameter and diraction for sort process
puts ("Please choose sort option (date_added|price): ")
order_by = gets.chomp

puts ("Please choose sort direction(desc|asc): ")
order_direction = gets.chomp


# condition for sort by parametere and diraction
order_by == "price"  ?  cars_file.sort_by! {|car| car[:price]} :  cars_file.sort_by! {|car| Date.strptime(car[:date_added], '%d/%m/%y')}

order_direction == "asc" ? cars_file : cars_file.reverse!

#call function to show the result of executing the request according to the specified parameters
show_requested_car(cars_file) 

