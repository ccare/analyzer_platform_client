
require 'pp'

require_relative "../lib/platform_client_context.rb"
require_relative "../lib/platform_connection.rb"

@context = PlatformClientContext.new
@socket = @context.open_socket
@socket.connect("tcp://52.48.43.253:5555")

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

def build_and_deploy(languge_slug, sha)

  msg = {
    action: :build_container,
    track_slug: languge_slug,
    channel: "test_runners",
    git_reference: sha
  }
  result = exchange(msg.to_json, 300_000)
  raise "error" unless result["status"]["status_code"] == 200

  msg = {
    action: :build_container,
    track_slug: languge_slug,
    channel: "test_runners",
    git_reference: sha
  }
  result = exchange(msg.to_json, 300_000)
  raise "error" unless result["status"]["status_code"] == 200

  msg = {
    action: :deploy_container_version,
    track_slug: languge_slug,
    channel: "test_runners",
    new_version: "git-#{sha}"
  }
  result = exchange(msg.to_json, 300_000)
  raise "error" unless result["status"]["status_code"] == 200
end


build_and_deploy("ruby", "41285e7491989b9dd334e29be29d0c1c120dd866")
build_and_deploy("csharp", "723ed358cd07f19062c3b48889fca9d8a2784b7c")
