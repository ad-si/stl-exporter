fs = require 'fs'
path = require 'path'

yaml = require 'js-yaml'
bufferConverter = require 'buffer-converter'

stlExporter = require './index'

mode = 'toAsciiStl'


module.exports = () ->
	if process.stdin.isTTY

		args = process.argv.slice(2)
		output = ''
		options = {}

		if not args.length
			console.log "Usage:
				#{path.basename process.argv[1]}
				[--ascii (default)| --binary]
				<json mesh-file>"
			return process.exit 1


		args.forEach (cliArgument) ->
			if /^\-\-/i.test(cliArgument)
				options[cliArgument.slice(2)] = true

		filePath = args.pop()

		if not path.isAbsolute filePath
			filePath = path.join process.cwd(), filePath


		jsonStl = yaml.safeLoad fs.readFileSync filePath


		if options.binary
			output = bufferConverter.toBuffer(
				stlExporter.toBinaryStl jsonStl
			)

		else
			output = stlExporter.toAsciiStl jsonStl


		process.stdout.write output

	else
		process.stdin.setEncoding 'utf-8'

		process.stdin
		.pipe stlExporter.getTransformStream()
		.pipe process.stdout