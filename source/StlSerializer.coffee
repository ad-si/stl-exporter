stream = require 'stream'


createFacetString = (face) ->
	{normal, vertices} = face

	return "facet normal #{normal.x} #{normal.y} #{normal.z}\n" +
			'outer loop\n' +
			"vertex #{vertices[0].x} #{vertices[0].y} #{vertices[0].z}\n" +
			"vertex #{vertices[1].x} #{vertices[1].y} #{vertices[1].z}\n" +
			"vertex #{vertices[2].x} #{vertices[2].y} #{vertices[2].z}\n" +
			'endloop\n' +
			'endfacet\n'


createBeautifiedFacetString = (face) ->
	{normal, vertices} = face

	return "facet normal #{normal.x} #{normal.y} #{normal.z}\n" +
			'\touter loop\n' +
			"\t\tvertex #{vertices[0].x} #{vertices[0].y} #{vertices[0].z}\n" +
			"\t\tvertex #{vertices[1].x} #{vertices[1].y} #{vertices[1].z}\n" +
			"\t\tvertex #{vertices[2].x} #{vertices[2].y} #{vertices[2].z}\n" +
			'\tendloop\n' +
			'endfacet\n'


class StlSerializer extends stream.Transform
	constructor: (@options = {}) ->
		@options.writableObjectMode ?= true
		@options.readableObjectMode ?= false
		super @options

		@internalBuffer = []
		@name = ''

	_flush: (done) ->
		@push "endsolid #{@name}\n"
		done()

	_transform: (chunk, encoding, done) ->
		@internalBuffer = @internalBuffer.concat chunk.split('\n')


		while data = @internalBuffer.shift()

			data = JSON.parse data

			if data.name
				@name = data.name
				@push "solid #{@name}\n"
				continue

			if @options.beautify
				@push createBeautifiedFacetString data
			else
				@push createFacetString data

		done()

module.exports = StlSerializer
