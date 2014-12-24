gutil      = require 'gulp-util'
through    = require 'through2'
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
                        console.log 'matchstart', matchStart
                        # only seek if group matches block name
                        seeking = matchStart isnt null and matchStart.length is 2 and matchStart[1] is group
                    else if seeking
                        matchEnd = value.match /endpathseeker/
                        console.log 'matchend', matchEnd
                        seeking = matchEnd is null
                    console.log 'seeking', seeking
                onattribute: (name, value) ->
                    if seeking and name in ['src', 'href']
                        console.log name, value

            parser.write file.contents.toString 'utf8'
            parser.end()
        @push file
        cb()