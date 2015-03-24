toAsciiStl = require './faceVertexMeshToAsciiStl.coffee'
toBinaryStl = require './faceVertexMeshToBinaryStl.coffee'

if typeof window isnt 'undefined'
	saveAs = require 'filesaver.js'

saveAsBinaryStl = (model) =>
	blob = new Blob [toBinaryStl(model)]

	saveAs blob, model.fileName


saveAsAsciiStl = (model) =>
	blob = new Blob [toAsciiStl(model)], {type: 'text/plain;charset=utf-8'}

	saveAs blob, model.fileName


module.exports =
	toAsciiStl: toAsciiStl
	toBinaryStl: toBinaryStl
	saveAsBinaryStl: saveAsBinaryStl
	saveAsAsciiStl: saveAsAsciiStl
