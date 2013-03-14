grunt.loadNpmTasks 'grunt-contrib-coffee'

grunt.initConfig \
  coffee:
    compile:
      files: { 'pkg/sumatra.js': ['lib/sumatra/*.js.coffee'] }
