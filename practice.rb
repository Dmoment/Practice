class Product

	attr_accessor :items
	def initialize(items , unit_price , sale_price) #initializer
		@items = items
		@unit_price = unit_price
		@sale_price = sale_price
		@total_original_price = 0
	end
	 
	def refined_items(items) #removing duplicate values and counting total quantities
		new_items = Hash.new(0)
		items.each do |item|
			new_items[item] += 1	
		end
		return new_items
	end 
	
	def price_calculation(items , refined_items_array) #price calculation
		new_unit_price = Hash.new
		total_price = 0
		@unit_price.each do |item , price|
			if( refined_items_array[item] >= @sale_price[item][0])
				new_unit_price[item] = @sale_price[item][1] + (refined_items_array[item] - @sale_price[item][0]) * price  
			else
				@new_unit_price[item] = (refined_items_array[item] * price)
			end
			@total_original_price +=  (refined_items_array[item] * price) 
		end
    return new_unit_price  
		
	end

	def order_print(new_unit_price , refined_items_array) #printing order reciept
		puts "Item   Quantity   Price"
		puts "------------------------"
		new_unit_price.each do|item , price|
			puts "#{item}  #{refined_items_array[item]}  #{price}"
		end
	end
	
	def saved_price(new_unit_price) #printing total and saveprice
		total = 0
		new_unit_price.each do |item , value|
			total += value
		end
		saving = @total_original_price - total
		puts "Total price : $#{total}"
		puts "You saved $ #{saving.round(2)} today"
	end
end


unit_price = {'milk'=> 3.97, 'bread'=> 2.17, 'banana'=>0.99,'apple'=>0.89} #static table
sale_price = { 'milk'=> [2,5], 'bread'=>[3,6],'banana'=>[0,0],'apple'=>[0,0]}
print ("Please enter all the items purchased separated by a comma")
items = []
items = gets.chomp.downcase.split(/ |, |,/).sort 
customer = Product.new(items , unit_price , sale_price) #singular item class
refined_items = customer.refined_items(items)
price_calculator = customer.price_calculation(items , refined_items)
customer.order_print(price_calculator , refined_items)
customer.saved_price(price_calculator)
puts price_calculator

