
# load module to work with yaml files
require 'yaml'

# load module to work with dates
require 'date' 

# create a function to display the result on the screen
def showRequestedCar 
    $arrWithCars.each do |car|
        car.each { |key, value| puts "#{key}: #{value}" }
        puts "---------------------------------------"
    end
end


$hashWithMyImputs = {}

# get argument for search request
puts "Please choose make: "
$hashWithMyImputs[:make] = gets.capitalize.chomp

puts "Please choose model: "
$hashWithMyImputs [:model] = gets.capitalize.chomp

puts "Please choose year_from: "
$hashWithMyImputs[:year_from] = gets.chomp

puts "Please choose year_to: "
$hashWithMyImputs[:year_to] = gets.chomp

puts "Please choose price_from: "
$hashWithMyImputs[:price_from] = gets.chomp

puts "Please choose price_to: "
$hashWithMyImputs[:price_to] = gets.chomp


# load a yaml file + symbolize all keys of hashes
$carsFile = YAML.safe_load_file('cars.yml', symbolize_names: true) 

#create a new array to save all cars from yaml 
$arrWithCars = []

def addAllCarsFromYALM
$carsFile.map do |car|
        $arrWithCars << car
    end
end

#call the function and add all our machines to the array
addAllCarsFromYALM

#$arrWithCars


def filterArrWithCarsByMakeAndModel(rule)
    skipByEmptyValue = $hashWithMyImputs[rule] == ""
    $arrWithCars.keep_if {|car| car[rule] == $hashWithMyImputs[rule] || skipByEmptyValue}
end


make = :make
model = :model

filterArrWithCarsByMakeAndModel(make)
filterArrWithCarsByMakeAndModel(model)

#puts $arrWithCars


def filterArrWithCarsByYearAndPrice(rule, parameterFrom, parameterTo)

    from = $hashWithMyImputs[parameterFrom]
    tok = $hashWithMyImputs[parameterTo]

    skipByEmptyFrom = from == ""
    skipByEmptyTo = tok == ""

    $arrWithCars.keep_if do |car|
        (car[rule] >= from.to_i || skipByEmptyFrom) && (car[rule] <= tok.to_i || skipByEmptyTo)
    end
end

#put the keys in separate variables
year = :year
year_from = :year_from
year_to = :year_to

#call a function that filter the array of cars according to the required parameters
#filter by given date of manufacture of the car
filterArrWithCarsByYearAndPrice(year, year_from, year_to)

#put the keys in separate variables
price = :price
price_from = :price_from
price_to = :price_to

#call a function that filter the array of cars according to the required parameters
#filter by the given price range
filterArrWithCarsByYearAndPrice(price, price_from, price_to)


# defolt sort by date_added. Sort by decline
$arrWithCars = $arrWithCars.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}.reverse 


# get order parameter and diraction for sort process
puts ("Please choose sort option (date_added|price): ")
orderBy = gets.chomp

puts ("Please choose sort direction(desc|asc): ")
orderDirection = gets.chomp


# condition for sort by parametere and diraction
orderBy == "price"  ?  $arrWithCars.sort_by! {|car| car[:price]} :  $arrWithCars.sort_by! {|car| Date.strptime(car[:date_added], '%d/%m/%y')}

orderDirection == "asc" ? $arrWithCars : $arrWithCars.reverse!

#call function to show the result of executing the request according to the specified parameters
showRequestedCar
