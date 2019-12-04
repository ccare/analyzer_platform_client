require 'rbczmq'
require 'json'

class PlatformConnection

  attr_reader :socket

  def initialize(socket)
    @socket = socket
  end

  def connect(address)
    socket.linger = 1
    socket.connect(address)
  end

  def send_msg(json, timeout_ms=10_000)
    socket.linger = timeout_ms * 2
    socket.rcvtimeo = timeout_ms

    msg = ZMQ::Message.new
    msg.push(ZMQ::Frame.new(json))

    puts "Sending msg"
    socket.send_message(msg)

    # Get the response back from the runner
    puts "Waiting for response"
    recvd_msg = socket.recv_message

    # TODO can be nil here

    puts "Got message"

    if recvd_msg.nil?
      puts "recv timeout"
      return {
        "status" => {
          "status_code" => 101,
          "message" => "Client Timeout"
        }
      }
    end

    response = recvd_msg.pop.data

    if response.nil?
      return {
        "status"=> {
            "status_code" => 102,
            "message" => "Malformed response",
            "error" => "Response was nil"
          }
        }
    end

    begin
      JSON.parse(response)
    rescue JSON::ParserError => e
      puts e.message
      puts e.backtrace
      {
        "status" => {
          "status_code" => 102,
          "message" => "Malformed response",
          "error" => "Response was not valid JSON. Got #{response}"
        }
      }
    end
  end

end
