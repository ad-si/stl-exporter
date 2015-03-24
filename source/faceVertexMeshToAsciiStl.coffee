module.exports = (model, options = {}) ->
	options.beautify ?= false
	options.fileName ?= 'model'

	{facesNormals, facesVerticesIndices, verticesCoordinates, name} = model

	stringifyFaceNormal = (i) ->
		facesNormals[i] + ' ' +
		facesNormals[i + 1] + ' ' +
		facesNormals[i + 2]

	stringifyVector = (i) ->
		verticesCoordinates[(i * 3)] + ' ' +
		verticesCoordinates[(i * 3) + 1] + ' ' +
		verticesCoordinates[(i * 3) + 2]


	stl = "solid #{name}\n"

	if options.beautify
		for i in [0...facesVerticesIndices.length] by 3
			stl += '\t' +
				"facet normal #{stringifyFaceNormal(i)}\n" +
				'\t\t' +
				'outer loop\n' +
				'\t\t\t' +
				"vertex #{stringifyVector(facesVerticesIndices[i])}\n" +
				'\t\t\t' +
				"vertex #{stringifyVector(facesVerticesIndices[i + 1])}\n" +
				'\t\t\t' +
				"vertex #{stringifyVector(facesVerticesIndices[i + 2])}\n" +
				'\t\t' +
				'endloop\n' +
				'\t' +
				'endfacet\n'

	else
		for i in [0...facesVerticesIndices.length] by 3
			stl += "facet normal #{stringifyFaceNormal(i)}\n" +
				'outer loop\n' +
				"vertex #{stringifyVector(facesVerticesIndices[i])}\n" +
				"vertex #{stringifyVector(facesVerticesIndices[i + 1])}\n" +
				"vertex #{stringifyVector(facesVerticesIndices[i + 2])}\n" +
				'endloop\n' +
				'endfacet\n'

	stl += "endsolid #{name}\n"

	return stl
