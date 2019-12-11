
require 'pp'

require_relative "../lib/platform_client_context.rb"
require_relative "../lib/platform_connection.rb"

@context = PlatformClientContext.new
@socket = @context.open_socket
@socket.connect("tcp://localhost:5555")

def exchange(msg)
  response = @socket.send_msg(msg, 10000)

  puts "- STATUS ---------------------"
  pp response["status"]
  puts "--------------------------------"

  puts "- RESPONSE ---------------------"
  pp response["response"]
  puts "--------------------------------"

  puts "- ADDITIONAL CONTEXT -----------"
  pp response["context"]
  puts "--------------------------------"

  response
end

msg = {
  action: "test_solution",
  track_slug: "ruby",
  container_version: "git-b6ea39ccb2dd04e0b047b25c691b17d6e6b44cfb",
  id: "_myid",
  exercise_slug: "xx",
  s3_uri: "xx"
}

result = exchange(msg.to_json)
pp result

puts "done"
