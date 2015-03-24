fs = require 'fs'
path = require 'path'
stlExporter = require('../source/index')
yaml = require 'js-yaml'
expect = require('chai').expect


faceVertexTetrahedron = yaml.safeLoad fs.readFileSync path.join(
	__dirname,
	'models/faceVertexTetrahedron.yaml'
)


describe 'STL Exporter', ->
	it 'exports an STL file', () ->
		minifiedTetrahedronStl = fs.readFileSync(
			path.resolve(
				__dirname,
				'../node_modules/stl-models/polytopes/tetrahedron.min.ascii.stl'
			),
			'utf-8'
		)

		convertedTetrahedronStl = stlExporter.toAsciiStl(faceVertexTetrahedron)

		expect(convertedTetrahedronStl).to.equal(minifiedTetrahedronStl)


	it 'exports an beautified STL file', () ->
		tetrahedronStl = fs.readFileSync(
			path.resolve(
				__dirname,
				'../node_modules/stl-models/polytopes/tetrahedron.ascii.stl'
			),
			'utf-8'
		)

		convertedTetrahedronStl = stlExporter.toAsciiStl(
			faceVertexTetrahedron,
			{beautify: true}
		)

		expect(convertedTetrahedronStl).to.equal(tetrahedronStl)
