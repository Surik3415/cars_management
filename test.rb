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



#open yaml file to sabe body of my requests
$searches = File.open("./searches.yml","a+")

#inirialize variable with finded cars as global var to work in other objects  
$myOnlyRes = myOnlyRes


#create class to create a requests
class Req

    #allow to make changes in parameters
    attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :orderBy, :orderDirection, :getQuantityOfSameReq

    #initialize constructor function to create a request
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

    #пубудивись це, бо походу ти це будеш видаляти 
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

#initialize my request
requestObject = Req.new(make, model, year_from, year_to, price_from, price_to, orderBy, orderDirection)

#create hash from object to save it in yaml file
$heshedObject = {}
requestObject.instance_variables.each {|var| $heshedObject[var.to_s.delete("@")] = requestObject.instance_variable_get(var) }



#open "./searches.yml" with my requests 
log = File.open("./searches.yml")
yp = YAML::load_stream(log) {|doc|

    # increament QuantityOfSameReq if same request was finded in yaml file 
 if ($heshedObject.to_a.slice(0,9) & doc.to_a.slice(0,9)) == doc.to_a.slice(0,9)
     $heshedObject["getQuantityOfSameReq"] += 1
 end  
}

#save request hash in yaml file
$searches.puts YAML.dump($heshedObject)
$searches.close

#puts a Statistic info about total quantity of finded car by last request and
#puts a Statistic info requests quantity with same parameters 
    puts " 
            Statistic:

            Total quantity: #{$heshedObject["totalQuantityOfCars"]}

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
