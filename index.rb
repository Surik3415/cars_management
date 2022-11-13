
# load module to work with yaml files
require 'yaml'

# load module to work with dates
require 'date' 

# create a function to display the result on the screen
def show_requested_car 
    $arr_with_cars.each do |car|
        car.each { |key, value| puts "#{key}: #{value}" }
        puts "---------------------------------------"
    end
end


$hash_with_my_imputs = {}

# get argument for search request
puts "Please choose make: "
$hash_with_my_imputs[:make] = gets.capitalize.chomp

puts "Please choose model: "
$hash_with_my_imputs [:model] = gets.capitalize.chomp

puts "Please choose year_from: "
$hash_with_my_imputs[:year_from] = gets.chomp

puts "Please choose year_to: "
$hash_with_my_imputs[:year_to] = gets.chomp

puts "Please choose price_from: "
$hash_with_my_imputs[:price_from] = gets.chomp

puts "Please choose price_to: "
$hash_with_my_imputs[:price_to] = gets.chomp


# load a yaml file + symbolize all keys of hashes
$cars_file = YAML.safe_load_file('cars.yml', symbolize_names: true) 

#create a new array to save all cars from yaml 
$arr_with_cars = []

def add_all_cars_from_YALM
$cars_file.map do |car|
        $arr_with_cars << car
    end
end

#call the function and add all our machines to the array
add_all_cars_from_YALM

#$arr_with_cars


def filter_arr_with_cars_by_make_and_model(rule)
    skip_by_empty_value = $hash_with_my_imputs[rule] == ""
    $arr_with_cars.keep_if {|car| car[rule] == $hash_with_my_imputs[rule] || skip_by_empty_value}
end


make = :make
model = :model

filter_arr_with_cars_by_make_and_model(make)
filter_arr_with_cars_by_make_and_model(model)

#puts $arr_with_cars


def filter_arr_with_cars_by_year_and_price(rule, parameter_from, parameter_to)

    from = $hash_with_my_imputs[parameter_from]
    tok = $hash_with_my_imputs[parameter_to]

    skip_by_empty_from = from == ""
    skip_by_empty_to = tok == ""

    $arr_with_cars.keep_if do |car|
        (car[rule] >= from.to_i || skip_by_empty_from) && (car[rule] <= tok.to_i || skip_by_empty_to)
    end
end

#put the keys in separate variables
year = :year
year_from = :year_from
year_to = :year_to

#call a function that filter the array of cars according to the required parameters
#filter by given date of manufacture of the car
filter_arr_with_cars_by_year_and_price(year, year_from, year_to)

#put the keys in separate variables
price = :price
price_from = :price_from
price_to = :price_to

#call a function that filter the array of cars according to the required parameters
#filter by the given price range
filter_arr_with_cars_by_year_and_price(price, price_from, price_to)


# defolt sort by date_added. Sort by decline
$arr_with_cars = $arr_with_cars.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}.reverse 


# get order parameter and diraction for sort process
puts ("Please choose sort option (date_added|price): ")
order_by = gets.chomp

puts ("Please choose sort direction(desc|asc): ")
order_direction = gets.chomp


# condition for sort by parametere and diraction
order_by == "price"  ?  $arr_with_cars.sort_by! {|car| car[:price]} :  $arr_with_cars.sort_by! {|car| Date.strptime(car[:date_added], '%d/%m/%y')}

order_direction == "asc" ? $arr_with_cars : $arr_with_cars.reverse!

#call function to show the result of executing the request according to the specified parameters
show_requested_car 
