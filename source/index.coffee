toAsciiStl = require './faceVertexMeshToAsciiStl'
toBinaryStl = require './faceVertexMeshToBinaryStl'
AsciiSerializer = require './AsciiSerializer'
BinarySerializer = require './BinarySerializer'

module.exports =
	toAsciiStl: toAsciiStl
	toBinaryStl: toBinaryStl
	getTransformStream: (options = {}) ->
		options.type ?= 'binary'

		if options.type is 'binary'
			return new BinarySerializer options

		if options.type is 'ascii'
			return new AsciiSerializer options

		throw new Error "Options type #{options.type} is not supported"