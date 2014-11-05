ArgumentProcessor = require './src/ArgumentProcessor'

# Test single switch, not required, and without secondary argument
ap = new ArgumentProcessor

ap.addSwitch
    key: '-initial'
    isRequired: false

parsed = ap.parse ['-initial']
console.log 'parsed: ', parsed

parsed2 = ap.parse []
console.log 'parsed2: ', parsed2

# Test single argument, without argument, but which is required
ap2 = new ArgumentProcessor

ap2.addSwitch
    key: '-subsequent'
    isRequired: true

try
    parsed = ap2.parse []
catch e
    console.log 'got exception: ', e
console.log 'parsed again: ', parsed

#Test single switch with argument
ap3 = new ArgumentProcessor

ap3.addSwitch
    key: '-t'
    hasArgument: true

parsed = ap3.parse ['-t', 'simple']
console.log parsed

#Test multiple arguments
ap4 = new ArgumentProcessor

ap4.addSwitches
    '-t':
        hasArgument: true
    '-env':
        hasArgument: true
    '-rootDir':
        hasArgument: true
        isRequired: false
        defaultValue: '/dev/exports'
    '-initial':
        hasArgument: false
    '-subsequent':
        hasArgument: false
    '-st':
        hasArgument: true
        isRequired: false
    '-senv':
        hasArgument: true
        isRequired: false

args = [
    '-t', 'simple'
    '-env', 'dev'
    '-rootDir', '/dev/exports'
]
parsed = ap4.parse args
console.log parsed
