# The prototype for all jQuery plugins created with the Sumatra framework.
class @SumatraPlugin
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
  #
  # If `action:` is set to `null`, this method will not bind `perform()` to
  # anything.
  bindEvents: ->
    if @action?
      @element.on @action, @perform

  # ## perform(event)
  #
  # The event binding that handles `action`. Override this with your own
  # method. You must override this method or the `bindEvents` method to
  # get this plugin to do anything.
  
# Define a Sumatra plugin as a jQuery plugin.
#
# Arguments:
# - **plugin_name:** The name of the plugin as called from jQuery.
# - **plugin_code:** A function that returns a single object, which responds
#                    to a constructor of 3 arguments at least.
#
# Example:
#     sumatra 'myPlugin', ->
#       class MyPlugin extends SumatraPlugin
#         action: null
#         initialize:
#           alert 'loaded'
@sumatra = (plugin_name, plugin_code) ->
  # Instantiate a PluginHelper and apply the current scope.
  PluginHelper = plugin_code.apply this

  # Define a jQuery plugin named `plugin_name`.
  jQuery.fn[plugin_name] = (options={}) ->
    @each (index, element) ->
      # For each element, create a `PluginHelper` instance
      # of the passed-in `plugin_code` and apply the jQuery
      # plugin parameters to the constructor. 
      new PluginHelper(element, index, options)
