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
#     sumatra 'clickToGo', ->
#       class ClickToGo extends SumatraPlugin
#         action: 'click'
#         defaults: { to: 'http://google.com' }
#         perform: (event) =>
#           if confirm "Are you sure you want to go to #{@options.goTo}?"
#             window.location = @options.goTo
#
# Then, when instantiating, just override them.
#
#     $('a').clickToGo(to: 'http://yahoo.com');
#
# This removes the need for writing that boilerplate options hash extend
# code every time you write a jQuery plugin that takes options. All
# plugins defined with `sumatra()` take an optional options hash, which is
# `{}` by default, in case your plugin doesn't require options.
class @SumatraPlugin
  # The event to bind to if `perform()` is defined.
  action: 'one'

  # A hash of attributes that are extended with an options hash passed
  # into the jQuery plugin upon instantiation. Useful for setting up
  # data that is required.
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
  # of this object.
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

# SumatraRuntime
# --------------
#
# Defines a jQuery plugin using a service object with a nice,
# consistent, CoffeeScript-style interface. Plugins can extend
# `SumatraPlugin`, a prototype that makes defining plugins with
# Sumatra easier.
#
# The runtime function returns the generated jQuery plugin to the
# global scope so it can be used in your application code.
#
# Arguments:
#
# - **plugin_name:** The jQuery plugin name, called like `$('div').myPlugin();`
# - **plugin_code:** A function that will be executed immediately and must return
# a single object that takes 3 parameters in its constructor. These parameters
# are the `element` being targeted by jQuery, the `index` at which it appears
# in the query, and the `options` hash passed during the instantiation of the
# jQuery plugin.
#
# Example:
#
#     sumatra 'myPlugin', ->
#       class MyPlugin extends SumatraPlugin
#         action: null
#         initialize:
#           alert 'loaded'
#
@sumatra = (plugin_name, plugin_code) ->
  # Instantiate a PluginHelper and apply the current scope. This can
  # be any object that responds to 3 parameters in its constructor
  # and will be set to whatever is returned by `plugin_code()`.
  PluginHelper = plugin_code.apply this

  jQuery.fn[plugin_name] = (options={}) ->
    @each (index, element) ->
      # For each element, create a `PluginHelper` instance
      # of the passed-in `plugin_code` and apply the jQuery
      # plugin parameters to the constructor. 
      new PluginHelper(element, index, options)
