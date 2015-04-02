toAsciiStl = require './faceVertexMeshToAsciiStl'
toBinaryStl = require './faceVertexMeshToBinaryStl'
StlSerializer = require './StlSerializer'

module.exports =
	toAsciiStl: toAsciiStl
	toBinaryStl: toBinaryStl
	getTransformStream: (options = {}) ->

		options.type ?= 'binary'

		return new StlSerializer options