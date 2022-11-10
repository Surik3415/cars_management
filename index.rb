puts "Hello world!"

# load module to work with yaml files
require 'yaml'

 # load module to work with dates
require 'date' 


# load a yaml file + symbolize all keys of hashes
$carsFile = YAML.safe_load_file('./cars.yml', symbolize_names: true) 

# function for creating an array of cars
def resolt (makePar, modelPar, year_fromPar ,year_toPar, price_fromPar, price_toPar)

    #create a new array to save a found cars by request
    arrWithCars = []

    #filter yaml file with car informatoin
    $carsFile.map do |car|
            if (car[:make] == makePar.capitalize || makePar == "") && (car[:model] == modelPar.capitalize || modelPar == "") && (car[:year] >= year_fromPar.to_i || year_fromPar == "") && (year_toPar.to_i >= car[:year] || year_toPar == "") && (car[:price] > price_fromPar.to_i || price_fromPar == "") && (price_toPar.to_i > car[:price] || price_toPar == "")
                #add diltered information to array
                arrWithCars << car
            end
        end
    return arrWithCars   
end


# get argument for search request
puts "Please choose make: "
make = gets.capitalize.chomp

puts "Please choose model: "
model = gets.capitalize.chomp

puts "Please choose year_from: "
year_from = gets.chomp

puts "Please choose year_to: "
year_to = gets.chomp

puts "Please choose price_from: "
price_from = gets.chomp

puts "Please choose price_to: "
price_to = gets.chomp


# create new array witch incluses all heshes with found cars
myOnlyRes = resolt(make, model, year_from, year_to, price_from, price_to) 

# defolt sort by date_added
myOnlyRes = myOnlyRes.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}.reverse 


# get order parameter and diraction for sort process
puts ("Please choose sort option (date_added|price): ")
orderBy = gets.chomp

puts ("Please choose sort direction(desc|asc): ")
orderDirection = gets.chomp


# condition for sort by parametere and diraction
if orderBy == "price" && orderDirection == "asc"                                             
    myOnlyRes =  myOnlyRes.sort_by {|car| car[:price]}
    
elsif orderBy == "price"
    myOnlyRes =  myOnlyRes.sort_by {|car| car[:price]}.reverse

elsif orderDirection == "asc" 
    myOnlyRes = myOnlyRes.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}

else 
    myOnlyRes = myOnlyRes.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}.reverse
end



# return my resolt console
for car in myOnlyRes
    puts "  
            Id: #{car[:id]}

            Make: #{car[:make]}

            Model: #{car[:model]}

            Year: #{car[:year]}

            Odometer: #{car[:odometer]}

            Price: #{car[:price]}

            Description: #{car[:description]}

            Date added: #{car[:date_added]}
__________________________________________________________________________________
    " 
end