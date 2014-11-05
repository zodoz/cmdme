assert = require 'assert'
should = require 'should'
ArgumentProcessor = require '../src/ArgumentProcessor'

newAP = -> new ArgumentProcessor

describe 'ArgumentProcessor', ->
    describe 'single argument', ->
        it 'should return that the argument was present', ->
            ap = newAP()

            ap.addSwitch
                argument: '-t'

            parsed = ap.parse ['-t']

            parsed['-t'].should.have.properties
                present: true
