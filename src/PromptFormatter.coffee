_ = require 'lodash'
_.str = require 'underscore.string'
chalk = require 'chalk'
Commander = require './Commander'

class PromptFormatter
    constructor: (commander) ->
        @commander = commander
        @subFormatters = []

    formatPrompt: (currentPrompt) ->
        pwd = @commander.pwd()
        homeDir = Commander.GET_USER_HOME() + ''
        if @commander.inSubdirOf homeDir
            currentPrompt = chalk.green '~' +
                chalk.yellow pwd.substring(homeDir.length+1)
        else
            currentPrompt = chalk.yellow pwd
        currentPrompt += chalk.white '> '
        @runSubFormatters currentPrompt

    runSubFormatters: (currentPrompt) ->
        for subFormatter in @subFormatters
            currentPrompt = subFormatter.formatPrompt currentPrompt
        return currentPrompt

    addSubFormatter: (subFormatter) ->
        @subFormatters.push subFormatter

module.exports = PromptFormatter
