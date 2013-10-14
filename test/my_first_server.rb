require 'webrick'

server = WEBRick::HTTPServer.new :port => 8080
trap('INT') { server.shutdown }

server.mount_proc('/') do |req, res|
  res.content_typee = 'text/text'
  res.body = req.path
end  

server.start