
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

msg = {
      action: :build_container,
      track_slug: "ruby",
      channel: "test_runners",
      git_reference: "da694960c8c8d5c27c50885966a4301c050ce83a" #"d88564f01727e76f3ddea93714bdf2ea45abef86"
      # git_reference: "039f2842cabcfdc66f7f96573144e8eb255ec6e1" #bd8a0a593fa647c5bdd366080fc1e20c1bda7cb9
    }

result = exchange(msg.to_json, 300_000) # - 502
raise "error" unless result["status"]["status_code"] == 502
