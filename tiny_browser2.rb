require 'net/http'  
require 'json'

puts "Please input path"
path = gets.chomp
puts "post or get?"
post_get = gets.chomp.upcase

host = 'localhost'     
port = 2345

def parse_response(response)
  top, @body = response.split(/\r\n\r\n/, 2)
  top_parts = top.split(/\r\n/)
  status_line = top_parts[0]
  @status = status_line.split(" ")[1]
  headers = top_parts[1..-1]
end

if post_get == "GET"
   	uri = URI.parse("http://localhost:2345/#{path}")
	response = Net::HTTP.get_response(uri)
	Net::HTTP.get_print(uri)            	               

elsif post_get == "POST"
	puts "What is the vikings name?"
	name = gets.chomp
	puts "What is their email?"
	email = gets.chomp
	viking = {:name => name, :email => email}

	host = 'localhost'
	port = 2345

uri = URI.parse("http://localhost:2345/#{path}")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
request.body = viking.to_json
response = http.request(request)
  	
end
