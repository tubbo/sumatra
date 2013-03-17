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
#                    a single object that takes 3 parameters in its constructor.
#                    These parameters are the `element` being targeted by jQuery,
#                    the `index` at which it appears in the query, and the `options`
#                    hash passed during the instantiation of the jQuery plugin.
#
# Example:
#     sumatra 'myPlugin', ->
#       class MyPlugin extends SumatraPlugin
#         action: null
#         initialize:
#           alert 'loaded'
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
