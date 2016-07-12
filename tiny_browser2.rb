require 'net/http'  
require 'json'

puts "Please input path"
path = gets.chomp
puts "post or get?"
post_get = gets.chomp.upcase

host = 'localhost'     
port = 2345

if post_get == "GET"
   	uri = URI.parse("http://localhost:2345/#{path}")
	response = Net::HTTP.get_response(uri)
	Net::HTTP.get_print(uri)            	
end               


if post_get == "POST"
	puts "What is the vikings name?"
	name = gets.chomp
	puts "What is their email?"
	email = gets.chomp
	viking = {:name => name, :email => email}

	uri = URI.parse("http://localhost:2345/#{path}")
	req = Net::HTTP::Post.new(uri)
	req.set_form_data(viking)

	res = Net::HTTP.start(host, port) do |http|
		http.request(req)
	end
end