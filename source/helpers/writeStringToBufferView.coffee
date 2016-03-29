textEncoding = require 'text-encoding'
TextEncoder = textEncoding.TextEncoder

module.exports = (string, bufferView) ->
	stringUint8array = new TextEncoder().encode string

	for index in [0...bufferView.byteLength]
		bufferView.setUint8 index, stringUint8array[index] || 0
