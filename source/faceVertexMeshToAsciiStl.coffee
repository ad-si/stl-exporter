createFacetString = require './helpers/createFacetString'
createBeautifiedFacetString = require './helpers/createBeautifiedFacetString'


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
		stl += createBeautifiedFacetString(
			vertexCoordinates,
			faceVertexIndices,
			faceNormalCoordinates
		)

	else
		stl += createFacetString(
			vertexCoordinates,
			faceVertexIndices,
			faceNormalCoordinates
		)

	stl += "endsolid #{name}\n"

	return stl
