puts "Hello world!"

# load module to work with yaml files
require 'yaml'

 # load module to work with dates
require 'date' 


# load a yaml file + symbolize all keys of hashes
$carsFile = YAML.safe_load_file('./cars.yml', symbolize_names: true) 

#function for creating an array of cars
def resolt (makePar, modelPar, year_fromPar ,year_toPar, price_fromPar, price_toPar)
    arrWithCars = []

    $carsFile.map do |car|
            if (car[:make] == makePar.capitalize || makePar == "") && (car[:model] == modelPar.capitalize || modelPar == "") && (car[:year] >= year_fromPar.to_i || year_fromPar == "") && (year_toPar.to_i >= car[:year] || year_toPar == "") && (car[:price] > price_fromPar.to_i || price_fromPar == "") && (price_toPar.to_i > car[:price] || price_toPar == "")
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


# new arr witch incluses all heshes with finded cars
myOnlyRes = resolt(make, model, year_from, year_to, price_from, price_to) 

# defolt sort by Date
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



# render for console
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

$searches = File.open("./searches.yml","a+")
$myOnlyRes = myOnlyRes



class Req
    attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :orderBy, :orderDirection, :getQuantityOfSameReq

    def initialize (make, model, year_from, year_to, price_from, price_to, orderBy, orderDirection)
        @make = make
        @model = model
        @year_from = year_from
        @year_to = year_to
        @price_from = price_from
        @price_to = price_to
        @orderBy = orderBy
        @orderDirection = orderDirection
        @totalQuantityOfCars = 0
        @getQuantityOfSameReq = 0

        getQuantityOfCars

    end

    def getQuantityOfCars
        
        if $myOnlyRes.length > 0
            @totalQuantityOfCars = $myOnlyRes.length
        end
        return @totalQuantityOfCars
    end

    def getQuantityOfSameReq
        
        returs @getQuantityOfSameReq += 1
    end

end


requestObject = Req.new(make, model, year_from, year_to, price_from, price_to, orderBy, orderDirection)


$heshedObject = {}
requestObject.instance_variables.each {|var| $heshedObject[var.to_s.delete("@")] = requestObject.instance_variable_get(var) }

$searches.puts YAML.dump($heshedObject)
$searches.close


log = File.open("./searches.yml")
yp = YAML::load_stream(log) {|doc|

 if ($heshedObject.to_a.slice(0,9) & doc.to_a.slice(0,9)) == doc.to_a.slice(0,9)
     $heshedObject["getQuantityOfSameReq"] += 1
 end
   
}

    puts " 
            Statistic:

            Total Quantity: #{$heshedObject["totalQuantityOfCars"]}

            Requests quantity: #{$heshedObject["getQuantityOfSameReq"]}
__________________________________________________________________________________
            "

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
