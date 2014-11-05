require 'shelljs/global'
hasAnsi = require 'has-ansi'
stripAnsi = require 'strip-ansi'
chalk = require 'chalk'
readline = require 'readline'
Commander = require './src/Commander'
PromptFormatter = require './src/PromptFormatter'
ZilliantCommands = require './src/ZilliantCommands'

commander = new Commander()
promptFormatter = new PromptFormatter commander
zilliantCommands = new ZilliantCommands commander

# fix from http://stackoverflow.com/questions/23569878/adding-color-to-repl-prompt-node
_setPrompt = readline.Interface.prototype.setPrompt
readline.Interface.prototype.setPrompt = ->
    if arguments.length is 1 and hasAnsi arguments[0]
        _setPrompt.call this, arguments[0], stripAnsi(arguments[0]).length
    else
        return _setPrompt.apply this, arguments

completer = (linePartial, callback) ->
    options = 'one two three four five six seven eight nine ten'.split ' '
    hits = options.filter (c) ->
        c.indexOf(linePartial) is 0
    res = if hits.length > 0 then hits else options
    callback null, [res, linePartial]

rl = readline.createInterface
    input: process.stdin
    output: process.stdout
    completer: completer
    terminal: true

if true #debug?
  rl.setPrompt promptFormatter.formatPrompt()
  rl.prompt()

  rl.on 'line', (line) ->
      commander.run line.trim()
      rl.setPrompt promptFormatter.formatPrompt()
      rl.prompt()
  rl.on 'close', ->
      process.exit 0
else
  console.log 'running "export -f outFolder"'
  commander.run 'export -f outFolder'
  process.exit 0
