require 'socket'

hostname = 'localhost'
port = 2345

s = TCPSocket.open(hostname, port)

while line = s.gets 
	puts line.chop
end
s.close