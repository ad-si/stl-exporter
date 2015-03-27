fs = require 'fs'
path = require 'path'
stlExporter = require './index'
yaml = require 'js-yaml'


module.exports = () ->

	if process.argv.length < 3
		console.log "Usage: #{path.basename process.argv[1]} <json mesh-file>"
		return process.exit 1

	filePath = process.argv[2]

	if not path.isAbsolute(filePath)
		filePath = path.join process.cwd(), filePath

	console.log stlExporter.toAsciiStl yaml.safeLoad(
		fs.readFileSync filePath
	)
