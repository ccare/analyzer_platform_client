
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
  container_version: "git-da694960c8c8d5c27c50885966a4301c050ce83a",
  id: "_myid",
  exercise_slug: "two-fer",
  s3_uri: "s3://exercism-submissions/production/submissions/96"
}

result = exchange(msg.to_json)
raise "error" unless result["status"]["status_code"] == 200

pp result

puts "done"
