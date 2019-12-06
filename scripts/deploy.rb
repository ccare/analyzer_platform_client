
require 'pp'

require_relative "../lib/platform_client_context.rb"
require_relative "../lib/platform_connection.rb"

@context = PlatformClientContext.new
@socket = @context.open_socket
@socket.connect("tcp://localhost:5555")

def exchange(msg, timeout=10000)
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

def deploy_test_runner(languge_slug, version)
  msg = {
    action: :deploy_container_version,
    track_slug: languge_slug,
    channel: "test_runners",
    new_version: version
  }
  result = exchange(msg.to_json)
  raise "error" unless result["status"]["status_code"] == 200
end

deploy_test_runner("rust", "git-91aca5f26365595d76bf60b114a6eeefc3d416a5")
deploy_test_runner("csharp", "git-6e7b53c8572dd9475a2108726022952b9de50fde")
deploy_test_runner("elixir", "git-a8c7b8e5c1881792c4169e816c7b737b2ba7305c")
deploy_test_runner("python", "git-777031cbe192bbc567fd5b5253db4b0545621e6c")
