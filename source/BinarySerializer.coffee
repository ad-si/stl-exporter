stream = require 'stream'
bufferConverter = require 'buffer-converter'
writeStringToBufferView = require './helpers/writeStringToBufferView'

class BinarySerializer extends stream.Transform
	constructor: (@options = {}) ->
		@options.writableObjectMode ?= true
		@options.readableObjectMode ?= false
		#@options.encoding ?= 'binary'
		super @options

		@internalBuffer = []
		@name = ''


		# Lengths in byte
		@headerLength = 80 # 80 * uint8
		@facetsCounterLength = 4 # 1 * uint32
		@vectorLength = 12 # 3 * float32
		@attributeByteCountLength = 2 # 1 * uint16
		@facetLength = (@vectorLength * 4 + @attributeByteCountLength)
		@littleEndian = true
	# @contentLength = (@faceVertexIndices.length / 3) * @facetLength
	# @bufferLength = @headerLength + @facetsCounterLength + @contentLength

	_createFacetString: (face) ->
		{normal, vertices} = face

		arrayBuffer = new ArrayBuffer @facetLength
		dataView = new DataView arrayBuffer
		offset = 0

		# Normal
		dataView.setFloat32 offset, normal.x, @littleEndian
		dataView.setFloat32 offset += 4, normal.y, @littleEndian
		dataView.setFloat32 offset += 4, normal.z, @littleEndian

		# X,Y,Z-Vector
		for index in [0..2]
			dataView.setFloat32 offset += 4, vertices[index].x, @littleEndian
			dataView.setFloat32 offset += 4, vertices[index].y, @littleEndian
			dataView.setFloat32 offset += 4, vertices[index].z, @littleEndian


		# Attribute Byte Count
		dataView.setUint16 offset += 4, 0, @littleEndian
		offset += 2

		return bufferConverter.toBuffer arrayBuffer


	_flush: (done) ->
		done()

	_transform: (chunk, encoding, done) ->
		@internalBuffer = @internalBuffer.concat chunk.split('\n')

		while data = @internalBuffer.shift()

			data = JSON.parse data

			if data.hasOwnProperty 'name'
				@name = data.name

				arrayBuffer = new ArrayBuffer(
					@headerLength + @facetsCounterLength
				)
				headerView = new DataView arrayBuffer, 0, @headerLength
				dataView = new DataView arrayBuffer, @headerLength

				writeStringToBufferView @name, headerView

				# Set facets-counter
				dataView.setUint32(0, data.faceCount || 0, @littleEndian)

				@push bufferConverter.toBuffer arrayBuffer

				continue

			if data.hasOwnProperty 'vertices'
				@push @_createFacetString data

		done()

module.exports = BinarySerializer
