fs = require 'fs'
path = require 'path'
stlExporter = require('../source/index')
yaml = require 'js-yaml'
expect = require('chai').expect


describe 'STL Exporter', ->
	it 'exports an STL file', () ->
		tetrahedron = yaml.safeLoad fs.readFileSync path.join(
			__dirname,
			'models/faceVertexTetrahedron.yaml'
		)

		tetrahedronStl = fs.readFileSync(
			path.resolve(
				__dirname,
				'../node_modules/stl-models/polytopes/tetrahedron.ascii.stl'
			),
			'utf-8'
		)

		convertedTetrahedronStl = stlExporter.toAsciiStl(
			tetrahedron,
			{beautify: true}
		)

		expect(convertedTetrahedronStl).to.equal(tetrahedronStl)
