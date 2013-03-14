exec = require('child_process').exec

task 'build:javascript', "Compile Sumatra into JavaScript", ->
  exec 'coffee --join pkg/sumatra.js --compile lib/sumatra/*.coffee'

task 'build:coffeescript', "Compile Sumatra into CoffeeScript", ->
  fs = require 'fs'
  src = fs.readFileSync 'lib/sumatra/plugin.js.coffee'
  src += fs.readFileSync 'lib/sumatra/runtime.js.coffee'
  fs.writeFile 'pkg/sumatra.coffee', src, (err) ->
    throw err if err

task 'build', "Compile Sumatra into both languages", ->
  invoke 'build:coffeescript'
  invoke 'build:javascript'
