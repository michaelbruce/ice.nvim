require 'socket'
require_relative 'bencode'

# XXX try catch when the connection is refused (repl is not running)
# XXX should not send test-id, try using something else like test-running etc

def send(code, log=[])
  include Bencode
  socket = TCPSocket.open('127.0.0.1', 9999)
  socket.sendmsg 'd2:op5:clonee'
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  session = decoded["new-session"]
  session_length = decoded["new-session"].length
  socket.sendmsg "d4:code#{code.length}:#{code}2:id7:test-id2:op4:eval7:session#{session_length}:#{session}e"
  # return socket # XXX uncomment for test.rb

  catch (:complete) do
    while true
      message = socket.recvmsg.first
      decode_all(message).each do |dict|
        log << dict
        throw :complete if dict['status'] == 'done'
      end
    end
  end
end

def run_tests
  # XXX doesn't pick up tests
  include Bencode
  socket = TCPSocket.open('127.0.0.1', 9999)
  socket.sendmsg 'd2:op5:clonee'
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  session = decoded["new-session"]
  session_length = decoded["new-session"].length
  socket.sendmsg "d4:code24:(clojure.test/run-tests)2:id7:test-id2:op4:eval7:session#{session_length}:#{session}e"
  socket.recvmsg # Run the first time, ignore the 'started' message
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  decoded["out"].to_s.gsub('"', '\"')
end
