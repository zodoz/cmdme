_ = require 'lodash'
_.str = require 'underscore.string'
shelljs = require 'shelljs'
path = require 'path'

class Commander
  constructor: ->
    @addFunctionsOf shelljs

  addFunctionsOf: (newFunctionObject) ->
    Commander.prototype[name] = fn for name, fn of newFunctionObject when typeof fn is 'function'
    #for name, fn of newFunctionObject when typeof fn is 'function'
    #    Commander.prototype[name] = fn

  run: (line) ->
    return if line.length is 0
    [command, args...] = _.str.words line
    if @[command]?
      @[command] args
    else
      exec line #from shelljs.exec()

  exit: () ->
    process.exit 0

  inSubdirOf: (dir) ->
    pwd().indexOf(path.resolve dir) is 0

  inRelativeSubdirOf: (dir) ->
    pwd().indexOf(path.resolve dir) > 0

  normalizePath: (pathToNormalize) ->
    path.resolve pathToNormalize

  @GET_USER_HOME: ->
    process.env[Commander.GET_ENV_USER_HOME()]

  @GET_ENV_USER_HOME: ->
    if process.platform is 'win32' then 'USERPROFILE' else 'HOME'

module.exports = Commander
