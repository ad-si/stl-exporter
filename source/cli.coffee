fs = require 'fs'
path = require 'path'

yaml = require 'js-yaml'
bufferConverter = require 'buffer-converter'

stlExporter = require './index'

mode = 'toAsciiStl'


module.exports = () ->

	output = ''

	if process.argv.length < 3
		console.log "Usage:
			#{path.basename process.argv[1]}
			[--ascii (default)| --binary]
			<json mesh-file>"
		return process.exit 1

	if process.argv[2] is '--binary' or process.argv[2] is '--ascii'
		filePath = process.argv[3]

	else
		filePath = process.argv[2]

	if not path.isAbsolute filePath
		filePath = path.join process.cwd(), filePath


	jsonStl = yaml.safeLoad fs.readFileSync filePath


	if process.argv[2] is '--binary'
		output = bufferConverter.toBuffer(
			stlExporter.toBinaryStl jsonStl
		)

	else
		output = stlExporter.toAsciiStl jsonStl


	process.stdout.write output
