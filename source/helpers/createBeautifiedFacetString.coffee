module.exports = (vertexCoordinates, faceVertexIndices,
                  faceNormalCoordinates) ->
	stl = ''

	stringifyFaceNormal = (index) ->
		faceNormalCoordinates[index] + ' ' +
			faceNormalCoordinates[index + 1] + ' ' +
			faceNormalCoordinates[index + 2]

	stringifyVector = (index) ->
		vertexCoordinates[(index * 3)] + ' ' +
			vertexCoordinates[(index * 3) + 1] + ' ' +
			vertexCoordinates[(index * 3) + 2]

	for i in [0...faceVertexIndices.length] by 3
		stl += '\t' +
			"facet normal #{stringifyFaceNormal(i)}\n" +
			'\t\t' +
			'outer loop\n' +
			'\t\t\t' +
			"vertex #{stringifyVector(faceVertexIndices[i])}\n" +
			'\t\t\t' +
			"vertex #{stringifyVector(faceVertexIndices[i + 1])}\n" +
			'\t\t\t' +
			"vertex #{stringifyVector(faceVertexIndices[i + 2])}\n" +
			'\t\t' +
			'endloop\n' +
			'\t' +
			'endfacet\n'

	return stl