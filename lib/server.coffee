JSONStream = require './jsonstream'
{EventEmitter2} = require 'eventemitter2'

# Emits 'error', 'close', 'connection'
class Server extends EventEmitter2
  constructor: (@socket, @emitter) ->
    super()
    @streams = []
    @socket.on 'connection', (conn) => @_gotConnection conn
    
    ref = this
    @emitter.onAny (args...) -> ref._sendEvent this.event, args
  
  _gotConnection: (conn) ->
    address = conn.address()
    @emit 'connection', address
    
    stream = new JSONStream conn
    @streams.push stream
    stream.on 'packet', (p) => @_handlePacket p
    stream.on 'error', (e) =>
      @emit 'error', e, address
      stream.end()
      return if (index = @streams.indexOf stream) < 0
      @streams.splice index, 1
    conn.on 'close', =>
      @emit 'close', address
      return if (index = @streams.indexOf stream) < 0
      @streams.splice index, 1
    conn.on 'error', ->
    # send a list of methods as the first object
    stream.send @emitter.getMethodNames()
  
  _sendEvent: (event, args) ->
    obj = event: event, args: args
    for stream in @streams
      stream.send obj
  
  _handlePacket: (obj) ->
    throw new Error 'invalid packet' if typeof obj isnt 'object'
    throw new Error 'invalid packet' if not obj.args instanceof Array
    throw new Error 'invalid packet' if typeof obj.command isnt 'string'
    @emitter[obj.command].apply @emitter, obj.args

module.exports = Server
