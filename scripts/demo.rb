
require 'pp'

require_relative "../lib/platform_client_context.rb"
require_relative "../lib/platform_connection.rb"

@context = PlatformClientContext.new
@socket = @context.open_socket
@socket.connect("tcp://52.48.43.253:5555")

def exchange(msg)
  timeout = msg[:execution_timeout] || 10
  timeout = timeout * 1000
  msg = msg.to_json
  response = @socket.send_msg(msg, timeout)

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

# "rust", "git-91aca5f26365595d76bf60b114a6eeefc3d416a5")
# ("csharp", "git-6e7b53c8572dd9475a2108726022952b9de50fde")
# ("elixir", "git-a8c7b8e5c1881792c4169e816c7b737b2ba7305c")
# ("python", "git-777031cbe192bbc567fd5b5253db4b0545621e6c")

msg = {
  action: "test_solution",
  track_slug: "csharp",
  container_version: "git-723ed358cd07f19062c3b48889fca9d8a2784b7c",
  id: "_myid",
  exercise_slug: "csharp-1-b",
  s3_uri: "s3://exercism-submissions/production/testing/4b6535a2-079c-413a-a8ed-adbee54e77b7",
  execution_timeout: 30
}

result = exchange(msg)
raise "error" unless result["status"]["status_code"] == 200

pp result

puts "done"
