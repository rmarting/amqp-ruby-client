# AMQP Ruby Client

This repo includes a set of simple samples using Qpid-Proton with Ruby Clients.

# Prerequisites

Software needed:

* Ruby 2.2
* Qpid Proton packages for Ruby
* AMQP Ruby Gem
* AMQP endpoint to send/consume messages

A simple installation to run in a Fedora 28 workstation is:

    $ sudo dnf install rubygem-qpid_proton rubygem-qpid_proton-doc
    $ gem install qpid_proton amqp

[ActiveMQ Artemis](https://activemq.apache.org/artemis/) is a open source, high performance and scalable broker 
that implements AMQP protocol. You could install locally and test it using the Ruby Clients implemented here.

To install and start your local broker, please, refer the community documentation [here](https://activemq.apache.org/artemis/docs/latest/using-server.html)

# Senders

These classes send a number of messages using AMQP. There is a simple class to send a text message and 
other class to send the content of a file.

Pattern of use

    $ ruby send-file.rb <connection-url> <address> <message-number> <path-to-file>

Sample of use (text message):

    $ ruby send.rb amqp://user:password@localhost:5672 SampleQueue 10 'This a simple message'

Sample of use (file):

    $ ruby send-file.rb amqp://user:password@localhost:5672 SampleQueue 10 ./message-body-content.txt

# Receivers

This class consumes a number of messages using AMQP.

Sample of use (one message):

    $ ruby receive.rb amqp://user:password@localhost:5672 SampleQueue

Sample of use (10 messages):

    $ ruby receive.rb amqp://user:password@localhost:5672 SampleQueue 10

# Main References

* [Qpid Proton](https://qpid.apache.org/proton/)
* [Qpid Proton AMQP Library - Ruby](https://qpid.apache.org/releases/qpid-proton-0.24.0/proton/ruby/api/index.html)
* [Proton Ruby Examples](https://qpid.apache.org/releases/qpid-proton-0.24.0/proton/ruby/examples/index.html)
* [qpid_proton Ruby Gem](https://rubygems.org/gems/qpid_proton/)
