gutil   = require 'gulp-util'
through = require 'through2'

module.exports = (opts) ->
    console.log 'ding'
    through.obj (file, enc, cb) ->
        console.log 'through', file