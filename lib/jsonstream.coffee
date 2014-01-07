{EventEmitter} = require 'events'

###
Each packet: xyzw<data of length xyzw>
xyzw is a hex number.
Events:
- 'error': an invalid packet is received
- 'packet': a JSON object is received
###
class JSONStream extends EventEmitter
  constructor: (@socket) ->
    buffer = new Buffer('')
    @cbFunc = (d) =>
      buffer = Buffer.concat [buffer, d]
      if buffer.length >= 4
        if isNaN len = parseInt buffer[0...4], 16
          return @emit 'error', new Error 'invalid length field'
        if len + 4 <= buffer.length
          packet = buffer[4...len + 4]
          buffer = buffer[len + 4..]
          try
            parsedPacket = JSON.parse packet
          catch e
            @emit 'error', e
          @emit 'packet', parsedPacket
    @socket.on 'data', @cbFunc
  
  send: (packet) ->
    data = new Buffer JSON.stringify packet
    string = data.length.toString 16
    if string.length > 4
      throw new Error 'encoded packet was too long!'
    string = '0' + string while string.length < 4
    @socket.write new Buffer string
    @socket.write data
  
  end: ->
    @socket.removeListener 'data', @cbFunc
    @socket.end()

module.exports = JSONStream
