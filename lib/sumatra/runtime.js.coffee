# Define a Sumatra plugin as a jQuery plugin.
#
# Example:
#     sumatra 'myPlugin', ->
#       class MyPlugin extends SumatraPlugin
#         action: null
#         initialize:
#           alert 'loaded'
@sumatra = (plugin_name, plugin_code) ->
  PluginHelper = plugin_code.apply this

  jQuery.fn[plugin_name] = (options={}) ->
    @each (index, element) ->
      new PluginHelper(element, index, options)
