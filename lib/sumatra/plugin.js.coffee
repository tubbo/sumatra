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
    @options = init_options
    @mergeOptions() and @initialize() and @bindEvents()

  # Merge `options` hash with the `defaults` as set in the definition
  # of this object. The SumatraPlugin is 
  mergeOptions: ->
    mergedOptions = @defaults
    $.extend mergedOptions, @options
    @options = mergedOptions

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
  # get this plugin to do anything.
  perform: (event) =>
    target = event.currentTarget
    throw "Error: `#{target}` has no event binding for '#{action}'."
