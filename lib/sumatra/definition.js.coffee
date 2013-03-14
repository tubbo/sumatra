# Define a Sumatra plugin as a jQuery plugin.
#
# Example:
#     sumatra 'myPlugin', ->
#       class MyPlugin extends SumatraPlugin
#         initialize:
#           delete @action
#           alert 'loaded'

jQuery = require 'jquery'
SumatraPlugin = require 'sumatra/plugin'
module.exports = (plugin_name, plugin_code) ->
  plugin_helper = plugin_code.apply(this)
  jQuery.fn[plugin_name] =>
    @each (index, element) ->
      new plugin_helper(element, index)
