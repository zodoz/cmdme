_ = require 'lodash'

class ArgumentProcessor
    constructor: (debug) ->
        @switches = {}
        @debug = debug || false

    defaultArgOptions:
        hasArgument: false
        isRequired: true
        defaultValue: false

    parse: (args) =>
        console.log "\nparsing", args if @debug
        errors = []
        groupedArguments = @_groupQuotedArguments args
        console.log "Grouped arguments:", groupedArguments if @debug
        parsedArgs = @_getArguments {}, groupedArguments, errors

        # check rules are met
        console.log @switches if @debug
        for arg, argOption of @switches
            console.log "\t inspecting", arg, argOption if @debug
            if argOption.isRequired and not parsedArgs[argOption.key]?
                errors.push "could not find required argument '#{arg}'"

        # apply default arguments
        for arg, argOption of @switches when argOption.defaultValue isnt false
            console.log "looking at default", arg, argOption if @debug
            if not parsedArgs[arg]?
                console.log "setting default value for #{arg} to
                    #{argOption.defaultValue}", argOption if @debug
                parsedArgs[arg] =
                    present: true
                    argument: argOption.defaultValue

        if errors.length > 0
            throw errors
        parsedArgs

    _getArguments: (parsedArgs, remainingArgs, errors) =>
        console.log 'get arguments called with', parsedArgs, remainingArgs if @debug
        return parsedArgs if remainingArgs.length is 0
        [arg, restArgs...] = remainingArgs
        if not @switches[arg]?
            errors.push "could not parse argument '#{arg}'"
            @_getArguments parsedArgs, restArgs, errors
        else
            argOption = @switches[arg]
            parsedArgs[arg] =
                present: true
            if argOption.hasArgument
                parsedArgs[arg].argument = restArgs[0]
                restArgs = restArgs[1..]
            if restArgs.length > 0
                @_getArguments parsedArgs, restArgs, errors
            else
                return parsedArgs

    _groupQuotedArguments: (args) =>
        console.log 'grouping quoted in', args.length if @debug
        return args if args.length is 0
        [first, rest...] = args
        console.log "looking for quotes in '#{first}'" if @debug
        if first.charAt(0) is '"'
            console.log "'#{first}' starts with quote" if @debug
            if first.charat(first.size()-1) is '"'
                console.log 'ending with quote' if @debug
                newargs = [first]
                newargs[2..] = @_groupQuotedArguments rest
            else
                rest[0] = "#{first} #{rest[0]}"
                @_groupQuotedArguments rest
        else if args.length > 1
            newargs = [first]
            newargs[2..] = @_groupQuotedArguments rest
            newargs
        else
            console.log 'returning last arg: ', args if @debug
            args

    create: =>
        console.log 'creating' if @debug
        parse: @_parse

    _mergeArgOptions:
        _.partialRight _.assign,
            (sentArgValue, defaultArgValue) ->
                console.log "\tcomparing sent='#{sentArgValue}',
                    default='#{defaultArgValue}'" if @debug
                ret = if sentArgValue? then sentArgValue else defaultArgValue
                console.log '\treturning ', ret if @debug
                return ret

    _mergeArgOptionsWithDefaults:
        _.partialRight ArgumentProcessor::_mergeArgOptions,
            ArgumentProcessor::defaultArgOptions

    addSwitches: (argOptions) =>
        errors = []
        for key, option of argOptions
            option.key = key
            try
                @addSwitch option
            catch e
                errors.push e

        # throw any errors which may have occured
        if errors.length > 0
            throw errors

    addSwitch: (argOption) =>
        errors = []
        console.log "adding option: '#{argOption.key}':\n", argOption if @debug
        if not argOption.key?
            errors.push 'Each argument object must have a key attribute'
        # throw encountered errors if any exist
        if errors.length > 0
            throw errors

        @switches[argOption.key] =
            @_mergeArgOptionsWithDefaults argOption

module.exports = ArgumentProcessor
