require 'qpid_proton'

class SendHandler < Qpid::Proton::MessagingHandler

  def initialize(conn_url, address, message_number, message_body)
    super()

    @conn_url     = conn_url
    @address      = address
    @expected     = message_number
    @message_body = message_body
    @sent         = 0
    @confirmed    = 0    
  end

  def on_container_start(container)
    conn = container.connect(@conn_url)
    conn.open_sender(@address)
  end

  # TODO Manage exceptions

  def on_sender_open(sender)
    puts "SEND: Opened sender for target address '#{sender.target.address}'\n"
  end

  def on_sendable(sender)
    while sender.credit > 0 && @sent < @expected
      # msg = Qpid::Proton::Message.new(contents, { :durable => true, :priority => 8 } )
      msg = Qpid::Proton::Message.new
      msg.body = @message_body
      msg.durable = true
      msg.priority = 8
      sender.send(msg)

      @sent = @sent + 1
      
      puts "Message #{@sent} sent"
    end
  end

  def on_tracker_accept(tracker)
    @confirmed = @confirmed + 1
    if @confirmed == @expected
      puts "All #{@expected} messages confirmed!"
      tracker.connection.close
    end
  end
end

if ARGV.size == 4
  conn_url, address, message_number, message_body = ARGV
else
  abort "Usage: send.rb <connection-url> <address> <message-number> <message-body>\n"
end

puts "Sending #{message_number} messages to #{conn_url}"

handler = SendHandler.new(conn_url, address, message_number.to_i, message_body)
container = Qpid::Proton::Container.new(handler)
container.run
