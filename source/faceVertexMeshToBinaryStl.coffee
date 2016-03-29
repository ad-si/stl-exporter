writeStringToBufferView = require './helpers/writeStringToBufferView.coffee'

module.exports = (model) ->
	{faceNormalCoordinates, faceVertexIndices, vertexCoordinates, name} = model

	# Length in byte
	headerLength = 80 # 80 * uint8
	facetsCounterLength = 4 # 1 * uint32
	vectorLength = 12 # 3 * float32
	attributeByteCountLength = 2 # 1 * uint16
	facetLength = (vectorLength * 4 + attributeByteCountLength)
	contentLength = (faceVertexIndices.length / 3) * facetLength
	bufferLength = headerLength + facetsCounterLength + contentLength

	buffer = new ArrayBuffer bufferLength
	headerView = new DataView buffer, 0, headerLength
	dataView = new DataView buffer, headerLength
	le = true # little-endian

	writeStringToBufferView name, headerView

	dataView.setUint32(0, (faceVertexIndices.length / 3), le)
	offset = facetsCounterLength

	for i in [0...faceVertexIndices.length] by 3
		# Normal
		dataView.setFloat32(offset, faceNormalCoordinates[i], le)
		dataView.setFloat32(offset += 4, faceNormalCoordinates[i + 1], le)
		dataView.setFloat32(offset += 4, faceNormalCoordinates[i + 2], le)

		# X,Y,Z-Vector
		for a in [0..2]
			dataView.setFloat32(
				offset += 4,
				vertexCoordinates[faceVertexIndices[i + a] * 3],
				le
			)
			dataView.setFloat32(
				offset += 4,
				vertexCoordinates[faceVertexIndices[i + a] * 3 + 1],
				le
			)
			dataView.setFloat32(
				offset += 4,
				vertexCoordinates[faceVertexIndices[i + a] * 3 + 2],
				le
			)

		# Attribute Byte Count
		dataView.setUint16(offset += 4, 0, le)
		offset += 2

	return buffer
