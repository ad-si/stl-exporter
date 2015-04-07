fs = require 'fs'
path = require 'path'

yaml = require 'js-yaml'
bufferConverter = require 'buffer-converter'

GenericStream = require './helpers/GenericStream'
BufferedStream = require './helpers/BufferedStream'
stlExporter = require '../source/index'


expect = require('chai').expect


faceVertexTetrahedronPath = path.join(
	__dirname,
	'models/faceVertexTetrahedron.yaml'
)
faceVertexTetrahedron = yaml.safeLoad fs.readFileSync faceVertexTetrahedronPath

faceVertexTrianglePath = path.join(
	__dirname,
	'models/faceVertexTriangle.yaml'
)
faceVertexTriangle = yaml.safeLoad fs.readFileSync faceVertexTrianglePath


describe 'STL Exporter', ->
	describe 'Buffered', ->
		it 'converts a face-vertex-mesh json object to an ascii STL string', ->
			minifiedTetrahedronStl = fs.readFileSync(
				path.resolve(
					__dirname,
					'../node_modules/stl-models/polytopes/',
					'tetrahedron.min.ascii.stl'
				),
				'utf-8'
			)

			convertedTetrahedronStl = stlExporter.toAsciiStl(
				faceVertexTetrahedron
			)

			expect(convertedTetrahedronStl).to.equal(minifiedTetrahedronStl)


		it 'converts a face-vertex-mesh json object
			to a beautified ascii STL string', ->
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


		it 'converts a face-vertex-mesh json object to a binary STL string', ->
			minifiedTetrahedronStl = fs.readFileSync(
				path.resolve(
					__dirname,
					'../node_modules/stl-models/polytopes/tetrahedron.bin.stl'
				)
			)

			convertedTetrahedronStl = bufferConverter.toBuffer(
				stlExporter.toBinaryStl faceVertexTetrahedron
			)

			expect(convertedTetrahedronStl)
			.to.deep.equal(minifiedTetrahedronStl)


	describe 'Streamed', ->
		it 'streams a binary STL file
to a beautified ascii STL stream', (done) ->
			bufferedStream = new BufferedStream
			bufferedStream.on 'finish', ->
				expect bufferedStream.internalBuffer
				.to.match /^tetrahedron/gi

				done()

			fs.createReadStream path.join(
				__dirname,
				'models/facesListTetrahedron.jsonl'
			), {encoding: 'utf-8'}
			.pipe stlExporter.getTransformStream {type: 'binary'}
			.pipe bufferedStream


		it 'transforms a polygon-mesh stream
to an ascii STL stream', (done) ->
			bufferedStream = new BufferedStream
			bufferedStream.on 'finish', ->
				expect bufferedStream.internalBuffer
				.to.contain 'solid'
				.and.to.contain 'endsolid'
				.and.to.contain 'facet'
				.and.to.contain 'endfacet'
				.and.to.contain 'normal'
				.and.to.contain 'vertex'

				done()

			fs.createReadStream path.join(
				__dirname,
				'models/facesListTetrahedron.jsonl'
			), {encoding: 'utf-8'}
			.pipe stlExporter.getTransformStream {type: 'ascii'}
			.pipe bufferedStream


		it 'transforms a polygon-mesh stream
to a beautified ascii STL stream', (done) ->
			bufferedStream = new BufferedStream
			bufferedStream.on 'finish', ->
				expect bufferedStream.internalBuffer
				.to.contain 'solid'
				.and.to.contain 'endsolid'
				.and.to.contain 'facet'
				.and.to.contain 'endfacet'
				.and.to.contain 'normal'
				.and.to.contain 'vertex'
				.and.to.contain '\t'

				done()

			fs.createReadStream path.join(
				__dirname,
				'models/facesListTetrahedron.jsonl'
			), {encoding: 'utf-8'}
			.pipe stlExporter.getTransformStream {type: 'ascii', beautify: true}
			.pipe bufferedStream