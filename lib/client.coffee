JSONStream = require './jsonstream'
{EventEmitter2} = require 'eventemitter2'

class Client extends EventEmitter2
  constructor: (@socket, callback) ->
    super()
    @stream = new JSONStream @socket
    @stream.once 'packet', (p) =>
      @_handleMethodList p
      callback()
    @stream.on 'error', (e) => @socket.end()
    
  _handleMethodList: (list) ->
    @stream.on 'packet', (p) => @_handlePacket p
    for name in list
      do (name) =>
        this[name] = (args...) =>
          @stream.send command: name, args: args
  
  _handlePacket: (obj) ->
    @emit obj.event, obj.args...

module.exports = Client
