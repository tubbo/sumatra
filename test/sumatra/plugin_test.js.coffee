SumatraPlugin = require 'sumatra/plugin'
$ = require 'jquery'
require('chai').should()

class MockPlugin extends SumatraPlugin
  action: 'test'
  initialize: ->
    @initialized = true
    @fired_event = false
  perform: (event) =>
    @element.text "event completed"
    @fired_event = true

describe 'A plugin defined with Sumatra', ->
  before ->
    @element = $('<div id="mock"></div>')
    @plugin = new MockPlugin(element[0], 0, {})

  it "inherits from a common interface", ->
    @plugin.should.be.a 'SumatraPlugin'

  it "instantiates with custom initialization code", ->
    @plugin.initialized.should.equal true

  it "executes the event handler when event is fired", ->
    @element.trigger('test').should.equal true
    @plugin.fired_event.should.equal true

  it "attaches to the right element", ->
    @plugin.element.should.equal element
