# Sumatra

Sumatra is a CoffeeScript framework for writing jQuery plugins harder,
better, faster, stronger.

You should use Sumatra if you...

- Encapsulate complex jQuery plugins in a service object and call an
  instance of that service object for each DOM element the plugin
  selector is passed
- Enjoy test-driven development, clear code, and convention over
  configuration
- Believe unicorns are real

## Why?

A lot of jQuery plugins are written to encapsulate a simple bit of
functionality used throughout the application. But jQuery's syntax was
designed to improve the way people write JavaScript. CoffeeScript has a
similar goal, but approaches it from a different angle, it compiles its
syntax into JavaScript but does so in a safe, syntactically correct and
(mostly) readable way. This framework unites the two, and finally allows
jQuery developers to build plugins in CoffeeScript without making their
code look, well, downright ugly!

## Installation

### Requirements

- jQuery
- CoffeeScript if you want to develop it..

We recommend Bower for installing Sumatra as a component:

```bash
$ bower install sumatra
```

However, you can also install Sumatra manually by just including the
`pkg/sumatra.js` file in your javascripts directory.

## Usage

Sumatra values convention over configuration, and its usage revolves
around an established pattern that hopefully others will find useful.

### Defining a Basic Plugin

After loading Sumatra, you can build jQuery plugins that are both clear
and superbly terse:

```coffeescript
sumatra 'clickMe', ->
  class ClickMe extends SumatraPlugin
    action: 'click'
    perform: (event) =>
      element_id = @element.attr('id') || '<div>'
      alert "You just clicked #{element_id}!"
```

All this plugin does is show an `alert()` when the element is clicked.
You can define a single action with `action:` and then define the
`perform()` event handler that binds to whatever action you've set
on the element.

To bind an element to this event, just call it like any normal
jQuery plugin:

```coffeescript
$('#my_element').clickMe();
```

### Parameters

You can also make plugins that pass in options. All Sumatra plugins
take an `options` hash as their only argument, regardless of whether
the service object uses them or not.

```coffeescript
sumatra 'ajaxSubmit', ->
  class AjaxSubmit extends SumatraPlugin
    action: 'submit'
    mergeOptions: ->
      @defaults = @_getFormDefaults()
      _.extend(@options, @defaults)

    perform: (event) =>
      event.preventDefault()
      event.stopPropagation()
      $.ajax @options

    _getFormDefaults: ->
      {
        url: @element.attr('action')
        type: @element.attr('method')
        error: (message, status, xhr) ->
          console.log status, message, xhr
          alert "#{status}: #{message}"
      }
```

This is an example of [ajaxSubmit from the jQuery.form plugin][jqform],
implemented using Sumatra. It would especially be useful when rendering
an inline response with JSON, using something such as Handlebars to
compile the JSON data into a logic-less client-side template...

```coffeescript
$('form').ajaxSubmit \
  dataType: 'json'
  success: (context) =>
    template = Handlebars.compile $('#response_template')
    response = template(context)
    @element.html response
```

### Basic Properties

As a by-product of the jQuery instantation process, each `SumatraPlugin`
comes with the following three properties, for free:

- **element:** References a single jQuery DOM Object, which can perform
  basic functionality on the page. It is obtained from the collection of
  objects which matched the plugin's selector upon instantiation.
- **index:** The index of the jQuery DOM Object in the collection of
  objects which matched the plugin's selector upon instantiation.
- **options:** A Hash-notated Object obtained as the only argument in
  the jQuery plugin when instantiated. This object is then merged with
  the `defaults` hash, which are default params in the plugin's
  definition, before initialization occurs.

### Workflow

Each SumatraPlugin has a "workflow" that is expressed as a series of
methods, all run in the `constructor` of the object. The constructor
is responsible for setup of the object's basic properties. This method
should never be overridden, instead, each step of the instantiation
process can be controlled by overriding one of the following methods:

- **mergeOptions:** Merge the options with the defaults hash. You can
  override this to use attributes from `@element` as defaults instead.
- **initialize:** The main override of the constructor method, this is
  where one would actually "construct" the objects they are going to be
  using in this plugin instance, bind events, and call helper methods.
- **bindEvents:** This is where the `action:` event should be bound in
  some way. In many cases, this is overridden to bind other events as
  well as the `action:`, or binding the event as a `$(document).on`.
- **perform:** The event handler of the plugin, this is normally called
  when the `action:` event is fired, but it must be defined if it is
  called or it will throw an error.

You can define more methods, but these are the only public methods that
should be overridden. Any method beginning with `_` is considered
"private" and should not be overridden. Please carry this convention
to your own code as well.

## Development

You can build this code into JavaScript by running the following
command at the root dir:

```bash
$ npm install && cake build
```

### Contributions

Contributions will be accepted via Git/GitHub pull requests, as long as
you write tests that prove your contributions work. We use Jasmine to
write tests in CoffeeScript (you know, for the actual framework?) and
RSpec to write tests for the Rails helpers.

### Releases

All releases will be made in both CoffeeScript and JavaScript, and
available simultaneously on the Bower and RubyGems package managers.
We use Bower to manage the standalone JavaScript code which has no
dependency on Sprockets, Rails, or anything Ruby.

This code is released under the [MIT License][LICENSE].

[jqform]: http://jquery.malsup.com/form
[LICENSE]: https://github.com/tubbo/sumatra/blob/master/LICENSE.md
[engine]: http://github.com/tubbo/sumatra-rails
