// Generated by CoffeeScript 1.6.1
(function() {
  var _this = this;

  this.SumatraPlugin = (function() {

    SumatraPlugin.prototype.action = 'one';

    SumatraPlugin.prototype.defaults = {};

    function SumatraPlugin(current_element, index_of_query, init_options) {
      var _this = this;
      this.perform = function(event) {
        return SumatraPlugin.prototype.perform.apply(_this, arguments);
      };
      this.element = $(current_element);
      this.index = index_of_query;
      this.options = _.extend(this.defaults, this.options);
      this.initialize() && this.bindEvents();
    }

    SumatraPlugin.prototype.mergeDefaultswith = function(options) {};

    SumatraPlugin.prototype.initialize = function() {
      return true;
    };

    SumatraPlugin.prototype.bindEvents = function() {
      if (this.action != null) {
        return this.element.on(this.action, this.perform);
      }
    };

    SumatraPlugin.prototype.perform = function(event) {
      var target;
      target = event.currentTarget;
      throw "Error: `" + target + "` has no event binding for '" + action + "'.";
    };

    return SumatraPlugin;

  })();

  this.sumatra = function(plugin_name, plugin_code) {
    var plugin_helper;
    plugin_helper = plugin_code.apply(this);
    return jQuery.fn[plugin_name] = function(options) {
      return this.each(function(index, element) {
        return new plugin_helper(element, index, options);
      });
    };
  };

}).call(this);
