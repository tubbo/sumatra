# Define a Sumatra plugin as a jQuery plugin.
#
# Example:
#     sumatra 'myPlugin', ->
#       class MyPlugin extends SumatraPlugin
#         action: null
#         initialize:
#           alert 'loaded'
@sumatra = (plugin_name, plugin_code) ->
  plugin_helper = plugin_code.apply(this)
  jQuery.fn[plugin_name] =>
    @each (index, element) ->
      new plugin_helper(element, index)
