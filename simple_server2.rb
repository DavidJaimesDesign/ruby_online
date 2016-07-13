require 'socket'
require 'uri'
require 'json'

WEB_ROOT = './public'

CONTENT_TYPE_MAPPING = {
	'html' => 'text/html',
	'txt' => 'text/plain',
	'png' => 'image/png',
	'jpg' => 'image/jpeg',
}

DEFAULT_CONTENT_TYPE = "application/octect-stream"

def content_type(path)
	ext = File.extname(path).split(".").last
	CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end

def requested_file(request_line)#this finds the path 
	request_uri = request_line.split(" ")[1]
	path = URI.unescape(URI(request_uri).path)

	clean = []
	parts = path.split("/")

	parts.each do |part|
		next if part.empty? || part == '.'
		part == '..'? clean.pop : clean << part
	end
	File.join(WEB_ROOT, *clean)
end


server = TCPServer.new('localhost',2345)

loop do
	socket = server.accept 
	request = socket.recv(100000000)
  	puts request.inspect
	request_header, request_body = request.split("\r\n\r\n", 2)
	path = requested_file(request)
	path = File.join(path, 'index.html') if File.directory?(path) #this makes just localhost link to the index.html file
	if File.exist?(path) && !File.directory?(path)
	File.open(path, "rb") do |file|
		socket.print "HTTP/1.1 200 OK\r\n" +
           			"Content-Type: #{content_type(file)}\r\n" +
		          	"Content-Length: #{file.size}\r\n" +
		           	"Connection: close\r\n"
		socket.print "\r\n"
			
		if request.split(" ")[0] == "GET"
			IO.copy_stream(file, socket)

		elsif request.split(" ")[0] == "POST"
			thanks = File.read(path)
			params = {}
			params[:viking] = JSON.parse(request_body)
			puts "XXX"
			puts params
			insert = "<li>Name: #{params[:viking]["name"]}</li><li>Email: #{params[:viking]["email"]}</li>"
			thanks.gsub!(/<%= yield %>/, insert)	
			socket.print thanks
			puts thanks	
		else 	
			puts "ERROR NOT A POST OR A GET REQUEST RE EVAL YO LIFE"
		end	
	end
	else
		message = "File not found\n"
		socket.print "HTTP/1.1 404 Not Found\r\n" + 
					"Content-Type: text/plain\r\n" +						 "Content-Length: #{message.size}\r\n" +
					"Connection: closer\r\n"
		socket.print "\r\n"

		socket.print message
	end
	socket.close
end