require 'qpid_proton'

class ReceiveHandler < Qpid::Proton::MessagingHandler
  def initialize(conn_url, address, desired)
    super()

    @conn_url = conn_url
    @address  = address

    @desired  = desired
    @received = 0
  end

  def on_container_start(container)
    conn = container.connect(@conn_url)
    conn.open_receiver(@address)
  end

  def on_receiver_open(receiver)
    puts "RECEIVE: Opened receiver for source address '#{receiver.source.address}'\n"
  end

  def on_message(delivery, message)
    @received += 1

    puts "RECEIVE: Received message '#{@received}'\n"

    if @received == @desired
      delivery.receiver.close
      delivery.receiver.connection.close
    end
  end
end

if ARGV.size == 2
  conn_url, address = ARGV
  desired = 1
elsif ARGV.size == 3
  conn_url, address, desired = ARGV
else 
  abort "Usage: receive.rb <connection-url> <address> [<message-count>]\n"
end

puts "Consuming #{desired} messages from #{conn_url}"

handler = ReceiveHandler.new(conn_url, address, desired.to_i)
container = Qpid::Proton::Container.new(handler)
container.run
