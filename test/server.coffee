{Emitter, Server} = require '../index'
net = require 'net'

class TestObject extends Emitter
  print: (data) ->
    console.log data
    @emit 'echo', data
  add: (a, b) ->
    @emit 'sum', a + b

object = new TestObject()
server = net.createServer()
realObj = new Server server, object
server.listen 1337
