
require 'pp'

require_relative "../lib/platform_client_context.rb"
require_relative "../lib/platform_connection.rb"

@context = PlatformClientContext.new
@socket = @context.open_socket
@socket.connect("tcp://localhost:5555")
# @socket.connect("tcp://52.48.43.253:5555")

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

result = exchange("foo") # - 502
raise "error" unless result["status"]["status_code"] == 502

result = exchange("{}") # - 502
raise "error" unless result["status"]["status_code"] == 502

result = exchange("{ \"action\": \"beep\"}") # - 501
raise "error" unless result["status"]["status_code"] == 501

result = exchange("{ \"action\": \"test_solution\"}") # - 502 (no track slug)
raise "error" unless result["status"]["status_code"] == 502

result = exchange("{ \"action\": \"represent\", \"track_slug\": \"parsnip\"}") # - 502 (no container_version slug)
raise "error" unless result["status"]["status_code"] == 502

result = exchange("{ \"action\": \"represent\", \"track_slug\": \"parsnip\", \"container_version\": \"1234\", \"id\": \"_myid\"}") # - 503 (no worker()
raise "error" unless result["status"]["status_code"] == 503

# 504


msg = {
  action: "test_solution",
  track_slug: "parsnip",
  container_version: "1234",
  id: "_myid",
  exercise_slug: "xx",
  s3_uri: "xx"
}

result = exchange(msg.to_json)
raise "error" unless result["status"]["status_code"] == 511


msg = {
  action: "test_solution",
  track_slug: "ruby",
  container_version: "git-b6ea39ccb2dd04e0b047b25c691b17d6e6b44cfb",
  id: "_myid",
  exercise_slug: "xx",
  s3_uri: "xx"
}

result = exchange(msg.to_json)
raise "error" unless result["status"]["status_code"] == 512

msg = {
  action: "test_solution",
  track_slug: "ruby",
  container_version: "git-b6ea39ccb2dd04e0b047b25c691b17d6e6b44cfb",
  id: "_myid",
  exercise_slug: "two-fer",
  s3_uri: "s3://exercism-submissions/production/submissions/96"
}

result = exchange(msg.to_json)
raise "error" unless result["status"]["status_code"] == 200

pp result


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
