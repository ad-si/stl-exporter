stream = require 'stream'
expect = require('chai').expect

class BufferedStream extends stream.Writable
	constructor: (@options = {}) ->
		@options.objectMode = true
		@internalBuffer = ''
		super @options

	_write: (chunk, encoding, done) ->
		@internalBuffer += chunk
		done()


module.exports = BufferedStream
