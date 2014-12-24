gutil      = require 'gulp-util'
through    = require 'through2'
path       = require 'path'
htmlparser = require 'htmlparser2'

module.exports = (group, opts) ->
    through.obj (file, enc, cb) ->
        if file.isBuffer()
            urls = []
            seeking = false
            parser = new htmlparser.Parser 
                oncomment: (value) ->
                    if not seeking
                        matchStart = value.match /pathseeker\:(\w+)/
                        # only seek if group matches block name
                        seeking = matchStart isnt null and matchStart.length is 2 and matchStart[1] is group
                    else if seeking
                        matchEnd = value.match /endpathseeker/
                        seeking = matchEnd is null
                onattribute: (name, value) ->
                    if seeking and name in ['src', 'href']
                        # ignore absolute urls
                        if not value.match /^https?\:\/\//
                            urls.push path.normalize path.join file.path, value
                onend: ->
                    console.log urls

            parser.write file.contents.toString 'utf8'
            parser.end()
        @push file
        cb()