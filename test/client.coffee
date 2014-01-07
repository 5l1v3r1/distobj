{Client} = require '../index'
net = require 'net'

socket = net.connect port: 1337, ->
  c = new Client socket, ->
    c.add 10, 20
    c.print 'hey there'
  c.on 'sum', (n) ->
    console.log 'got sum: ' + n
  c.on 'echo', (d) ->
    console.log 'got echo: ' + d
