
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

# DEPLOY new version
msg = {
  action: :deploy_container_version,
  track_slug: "ruby",
  channel: "test_runners",
  new_version: "git-da694960c8c8d5c27c50885966a4301c050ce83a"
}
result = exchange(msg.to_json)
raise "error" unless result["status"]["status_code"] == 200
