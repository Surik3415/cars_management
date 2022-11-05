puts "Hello world!"

require 'yaml' # підгрузка модуля для читання ямл вайлів
require 'date'


$carsFile = YAML.safe_load_file('./cars.yml', symbolize_names: true) #читаємо файл та робимо всі його ключі символами 


def resolt (makePar, modelPar, year_fromPar ,year_toPar, price_fromPar, price_toPar)
    arrWithCars = []

    $carsFile.map do |car|
            if (car[:make] == makePar.capitalize || makePar == "") && (car[:model] == modelPar.capitalize || modelPar == "") && (car[:year] >= year_fromPar.to_i || year_fromPar == "") && (year_toPar.to_i >= car[:year] || year_toPar == "") && (car[:price] > price_fromPar.to_i || price_fromPar == "") && (price_toPar.to_i > car[:price] || price_toPar == "")
                arrWithCars << car
            end
        end
    return arrWithCars   
end



puts "Please choose make: "
make = gets.chomp

puts "Please choose model: "
model = gets.chomp

puts "Please choose year_from: "
year_from = gets.chomp

puts "Please choose year_to: "
year_to = gets.chomp

puts "Please choose price_from: "
price_from = gets.chomp

puts "Please choose price_to: "
price_to = gets.chomp


myOnlyRes = resolt(make, model, year_from, year_to, price_from, price_to)
myOnlyRes = myOnlyRes.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}.reverse



puts ("Please choose sort option (date_added|price): ")
orderBy = gets.chomp

puts ("Please choose sort direction(desc|asc): ")
orderDirection = gets.chomp


if orderBy == "price" && orderDirection == "asc"
    myOnlyRes =  myOnlyRes.sort_by {|car| car[:price]}
    
elsif orderBy == "price"
    myOnlyRes =  myOnlyRes.sort_by {|car| car[:price]}.reverse

elsif orderDirection == "asc" 
    myOnlyRes = myOnlyRes.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}

else 
    myOnlyRes = myOnlyRes.sort_by {|car| Date.strptime(car[:date_added], '%d/%m/%y')}.reverse
end



#puts myOnlyRes

for car in myOnlyRes
    puts "  Id: #{car[:id]}

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

