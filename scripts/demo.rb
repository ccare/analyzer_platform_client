
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

# "rust", "git-91aca5f26365595d76bf60b114a6eeefc3d416a5")
# ("csharp", "git-6e7b53c8572dd9475a2108726022952b9de50fde")
# ("elixir", "git-a8c7b8e5c1881792c4169e816c7b737b2ba7305c")
# ("python", "git-777031cbe192bbc567fd5b5253db4b0545621e6c")

msg = {
  action: "test_solution",
  track_slug: "javascript",
  container_version: "git-d5402c2f9e1d4b01517675680fa21201c9344f91",
  id: "_myid",
  exercise_slug: "two-fer",
  s3_uri: "s3://exercism-submissions/production/submissions/96"
}

result = exchange(msg.to_json)
raise "error" unless result["status"]["status_code"] == 200

pp result

puts "done"
