require 'rbczmq'

class PlatformClientContext

  def initialize
    @context = ZMQ::Context.new(1)
  end

  def open_socket
    sock = @context.socket(ZMQ::REQ)
    PlatformConnection.new(sock)
  end

end
