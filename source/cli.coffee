fs = require 'fs'
path = require 'path'

yaml = require 'js-yaml'
bufferConverter = require 'buffer-converter'

stlExporter = require './index'

mode = 'toAsciiStl'


module.exports = () ->
	args = process.argv.slice(2)
	output = ''
	flags = {}

	args.forEach (cliArgument) ->
		if /^\-\-/i.test(cliArgument)
			flags[cliArgument.slice(2)] = true


	if process.stdin.isTTY

		if not args.length
			console.log "Usage:
					#{path.basename process.argv[1]}
					[--ascii (default)| --binary]
					<json mesh-file>"
			return process.exit 1

		filePath = args.pop()

		if not path.isAbsolute filePath
			filePath = path.join process.cwd(), filePath


		jsonStl = yaml.safeLoad fs.readFileSync filePath


		if flags.binary
			output = bufferConverter.toBuffer(
				stlExporter.toBinaryStl jsonStl
			)

		else
			output = stlExporter.toAsciiStl jsonStl


		process.stdout.write output

	else
		process.stdin.setEncoding 'utf-8'

		process.stdin
		.pipe stlExporter.getTransformStream {
			type: if flags.binary then 'binary' else 'ascii'
		}
		.pipe process.stdout