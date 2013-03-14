
(function(/*! Stitch !*/) {
  if (!this.require) {
    var modules = {}, cache = {}, require = function(name, root) {
      var path = expand(root, name), module = cache[path], fn;
      if (module) {
        return module.exports;
      } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
        module = {id: path, exports: {}};
        try {
          cache[path] = module;
          fn(module.exports, function(name) {
            return require(name, dirname(path));
          }, module);
          return module.exports;
        } catch (err) {
          delete cache[path];
          throw err;
        }
      } else {
        throw 'module \'' + name + '\' not found';
      }
    }, expand = function(root, name) {
      var results = [], parts, part;
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    }, dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    }
    this.require.define = function(bundle) {
      for (var key in bundle)
        modules[key] = bundle[key];
    };
  }
  return this.require.define;
}).call(this)({"sumatra.js": function(exports, require, module) {(function() {
  var sumatra;

  sumatra = require('sumatra/definition');

}).call(this);
}, "sumatra/definition.js": function(exports, require, module) {(function() {
  var SumatraPlugin, jQuery;

  jQuery = require('jquery');

  SumatraPlugin = require('sumatra/plugin');

  module.exports = function(plugin_name, plugin_code) {
    var plugin_helper,
      _this = this;
    plugin_helper = plugin_code.apply(this);
    return jQuery.fn[plugin_name](function() {
      return _this.each(function(index, element) {
        return new plugin_helper(element, index);
      });
    });
  };

}).call(this);
}, "sumatra/plugin.js": function(exports, require, module) {(function() {
  var SumatraPlugin,
    _this = this;

  module.exports = SumatraPlugin = (function() {

    SumatraPlugin.prototype.action = 'one';

    SumatraPlugin.prototype.defaults = {};

    function SumatraPlugin(current_element, index_of_query, init_options) {
      var _this = this;
      this.perform = function(event) {
        return SumatraPlugin.prototype.perform.apply(_this, arguments);
      };
      this.element = $(current_element);
      this.index = index_of_query;
      this.options = init_options;
      this.mergeOptions() && this.initialize() && this.bindEvents();
    }

    SumatraPlugin.prototype.mergeOptions = function() {
      var _;
      _ = require('underscore');
      return this.options = _.extend(this.defaults, this.options);
    };

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

}).call(this);
}});
