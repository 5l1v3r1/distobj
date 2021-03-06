{EventEmitter2} = require 'eventemitter2'

fixObject = (obj) ->
  return null if obj is null
  return obj if typeof obj == 'string'
  return obj if typeof obj == 'number'
  return obj.toString() if typeof obj == 'function'
  if typeof obj == 'object'
    if obj instanceof Array
      return (fixObject x for x in obj)
    if obj instanceof Error
      return new SendableError(obj)
    fixed = {}
    for own x, y of obj
      fixed[x] = fixObject y
    return fixed
  return obj

class SendableError
  constructor: (anError) ->
    {@message, @stack, @name} = anError
  toJSON: -> this
  toString: -> JSON.stringify this

class Emitter extends EventEmitter2
  emit: (type, args...) -> super type, fixObject(args)...

  # returns all method names from subclass
  getMethodNames: ->
    list = []
    for m of this
      continue if m[0] is '_'
      continue if typeof this[m] isnt 'function'
      continue if Emitter.prototype[m]?
      list.push m
    return list

exports.Emitter = Emitter
exports.SendableError = SendableError
