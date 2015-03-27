module.exports = (model, options = {}) ->
	options.beautify ?= false
	options.fileName ?= 'model'

	{faceNormalCoordinates, faceVertexIndices, vertexCoordinates, name} = model

	stringifyFaceNormal = (index) ->
		faceNormalCoordinates[index] + ' ' +
		faceNormalCoordinates[index + 1] + ' ' +
		faceNormalCoordinates[index + 2]

	stringifyVector = (index) ->
		vertexCoordinates[(index * 3)] + ' ' +
		vertexCoordinates[(index * 3) + 1] + ' ' +
		vertexCoordinates[(index * 3) + 2]


	stl = "solid #{name}\n"

	if options.beautify
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

	else
		for i in [0...faceVertexIndices.length] by 3
			stl += "facet normal #{stringifyFaceNormal(i)}\n" +
				'outer loop\n' +
				"vertex #{stringifyVector(faceVertexIndices[i])}\n" +
				"vertex #{stringifyVector(faceVertexIndices[i + 1])}\n" +
				"vertex #{stringifyVector(faceVertexIndices[i + 2])}\n" +
				'endloop\n' +
				'endfacet\n'

	stl += "endsolid #{name}\n"

	return stl
