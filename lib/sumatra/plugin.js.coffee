# SumatraPlugin
# -------------
#
# A prototype object for common actions when defining jQuery plugins
# in the Sumatra framework. It is designed so that you never have to
# override the constructor. Instead, the constructor sets up a common
# method interface for both initialization (which would happen after
# construction) and the binding of events, a common task in jQuery
# plugins. This prototype even handles some of that for you, with
# the default `bindEvents()` being bound to call the `perform()`
# method (which must be defined by the object extending `SumatraPlugin`)
# whenever the element it was constructed with triggers the event
# defined by `action`.
#
# So essentially, you can define almost any jQuery plugin using this
# interface, even though the only thing binding it to the `sumatra`
# function is its constructor that takes 3 parameters.
#
# `SumatraPlugin` also has facilities for dealing with an options hash
# and merging said options with defaults. You can define the default
# options for your plugin like so:
#
#   sumatra 'clickToGo', ->
#     class ClickToGo extends SumatraPlugin
#       action: 'click'
#       defaults: { to: 'http://google.com' }
#       perform: (event) =>
#         if confirm "Are you sure you want to go to #{@options.goTo}?"
#           window.location = @options.goTo
#
# Then, when instantiating, just override them.
#
#   $('a').clickToGo(to: 'http://yahoo.com');
#
# This removes the need for writing that boilerplate options hash extend
# code every time you write a jQuery plugin that takes options. All
# plugins defined with `sumatra()` take an optional options hash, which is
# `{}` by default, in case your plugin doesn't require options.
class @SumatraPlugin
  # 
  action: 'one'
  defaults: {}

  # Instantiate a `SumatraPlugin` and bind it to the current element
  # with options. This also initiates the workflow.
  #
  # **DO NOT OVERRIDE!!**
  constructor: (current_element, index_of_query, init_options) ->
    @element = $(current_element)
    @index = index_of_query
    @options = @mergeDefaultsWith init_options
    @initialize() and @bindEvents()

  # Merge `options` hash with the `defaults` as set in the definition
  # of this object. The SumatraPlugin is 
  mergeDefaultsWith: (options) ->
    _.extend @defaults, @options

  # Run custom constructor code, but blocks instantiation if this method
  # returns `false`. This method was pretty much designed to be overridden.
  initialize: ->
    true

  # Bind the `perform()` method to the `action` as set in the definition
  # of this plugin. Overriding this method removes the guarantee that
  # perform() will be called at all...
  bindEvents: ->
    if @action?
      @element.on @action, @perform

  # The event binding that handles `action`. Override this with your own
  # method. You must override this method or the `bindEvents` method to
  # get this plugin to do anything. It takes a single argument, `event`,
  # which represents the given DOMEvent represented by `action` as passed
  # in by `jQuery.on`.
  perform: null

