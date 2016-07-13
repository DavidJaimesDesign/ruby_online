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

	request_line = "POST /thanks.html HTTP/1.0"
    form_data = {viking: {name: name, email: email}}.to_json
    content_length = "Content-Length: #{form_data.length}"
    request = [request_line, content_length, "", form_data].join("\r\n")
    puts request

  	socket = TCPSocket.open(host, port)
  	socket.print(request)
  	response = socket.read
  	parse_response(response)
  	
end
#uri = URI.parse("http://localhost:2345/#{path}")
#	http = Net::HTTP.new(uri.host, uri.port)
#	request = Net::HTTP::Post.new(uri.request_uri)
#	request.set_form_data(viking)
#	response = http.request(request)