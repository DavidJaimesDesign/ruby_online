require 'net/http'  
require 'json'

puts "Please input path"
path = gets.chomp
puts "post or get?"
post_get = gets.chomp.upcase
	if post_get == "POST"
		puts "What is the vikings name?"
		vname = gets.chomp
		puts "What is their email?"
		email = gets.chomp
		post = {:viking =>{:name => vname, :email => email}}
	end

host = 'localhost'     
port = 2345
               
uri = URI.parse("http://localhost:2345/#{path}")
response = Net::HTTP.get_response(uri)
Net::HTTP.get_print(uri)

http = Net::HTTP.new(host, port)   
response = http.request(Net::HTTP::Get.new(uri.request_uri))

if post_get == "POST"
	response = Net::HTTP.post_form(uri, post.to_json)
end