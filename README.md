# Distributed Objects in Node.js

`distobj` provides a basic facility for accessing remote `EventEmitter`s over the network in Node.js. Internally, `distobj` uses JSON to encode arguments you pass, and to encode responses (which come in the form of events). Since Node.js is totally event based, `distobj` has no concept of *return values*.

# Usage

You can create and publish an object as follows in this CoffeeScript example:

    {Emitter, Server} = require 'distobj'
    net = require 'net'

    # simply subclass the Emitter class
    class TestObject extends Emitter
      print: (data) ->
        console.log data
        # events we emit are broadcasted
        @emit 'echo', data
      add: (a, b) ->
        @emit 'sum', a + b
    
    # create a new TestObject.
    object = new TestObject()
    # create a server with object on port 1337.
    server = net.createServer()
    realObj = new Server server, object
    server.listen 1337

To access that object from a different process, do this:

    {Client} = require 'distobj'
    net = require 'net'
    # create a connection
    socket = net.connect port: 1337, ->
      # create a client and await a callback
      c = new Client socket, ->
        # upon receiving this callback, the client is now configured
        # with all of the methods on the remote object
        c.add 10, 20
        c.print 'hey there'
      # treat c like a normal event emitter
      c.on 'sum', (n) ->
        console.log 'got sum: ' + n
      c.on 'echo', (d) ->
        console.log 'got echo: ' + d

As you can see, `distobj` makes it almost *too easy* to access objects over the network!
