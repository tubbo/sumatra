task 'build', "Compile Sumatra", ->
  stitch = require 'stitch'
  fs = require 'fs'
  pkg = stitch.createPackage(paths: [__dirname + '/lib'])

  pkg.compile (error, source) ->
    fs.writeFile 'src/sumatra.js', source, (error) ->
      throw error if error
