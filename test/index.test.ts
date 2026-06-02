import fs from "node:fs"
import path from "node:path"
import { fileURLToPath } from "node:url"

import yaml from "js-yaml"
import { describe, it, expect } from "vitest"

import * as stlExporter from "../src/index.js"
import type { FaceVertexMesh } from "../src/types.js"
import BufferedStream from "./helpers/BufferedStream.js"

const __dirname = path.dirname(fileURLToPath(import.meta.url))

const faceVertexTetrahedron = yaml.load(
  fs.readFileSync(path.join(__dirname, "models/faceVertexTetrahedron.yaml"), "utf-8"),
) as FaceVertexMesh

describe("STL Exporter", () => {
  describe("Buffered", () => {
    it("converts a face-vertex-mesh json object to an ascii STL string", () => {
      const minifiedTetrahedronStl = fs.readFileSync(
        path.resolve(
          __dirname,
          "../node_modules/stl-models/polytopes/tetrahedron.min.ascii.stl",
        ),
        "utf-8",
      )

      const convertedTetrahedronStl = stlExporter.toAsciiStl(faceVertexTetrahedron)

      expect(convertedTetrahedronStl).to.equal(minifiedTetrahedronStl)
    })

    it("converts a face-vertex-mesh json object to a beautified ascii STL string", () => {
      const tetrahedronStl = fs.readFileSync(
        path.resolve(
          __dirname,
          "../node_modules/stl-models/polytopes/tetrahedron.ascii.stl",
        ),
        "utf-8",
      )

      const convertedTetrahedronStl = stlExporter.toAsciiStl(faceVertexTetrahedron, {
        beautify: true,
      })

      expect(convertedTetrahedronStl).to.equal(tetrahedronStl)
    })

    it("converts a face-vertex-mesh json object to a binary STL string", () => {
      const minifiedTetrahedronStl = fs.readFileSync(
        path.resolve(
          __dirname,
          "../node_modules/stl-models/polytopes/tetrahedron.bin.stl",
        ),
      )

      const convertedTetrahedronStl = Buffer.from(
        stlExporter.toBinaryStl(faceVertexTetrahedron),
      )

      expect(convertedTetrahedronStl).to.deep.equal(minifiedTetrahedronStl)
    })
  })

  describe("Streamed", () => {
    const facesListPath = path.join(__dirname, "models/facesListTetrahedron.jsonl")

    it("streams a binary STL file to a beautified ascii STL stream", () =>
      new Promise<void>((done) => {
        const bufferedStream = new BufferedStream()
        bufferedStream.on("finish", () => {
          expect(bufferedStream.internalBuffer).to.match(/^tetrahedron/gi)
          done()
        })

        fs.createReadStream(facesListPath, { encoding: "utf-8" })
          .pipe(stlExporter.getTransformStream({ type: "binary" }))
          .pipe(bufferedStream)
      }))

    it("transforms a polygon-mesh stream to an ascii STL stream", () =>
      new Promise<void>((done) => {
        const bufferedStream = new BufferedStream()
        bufferedStream.on("finish", () => {
          expect(bufferedStream.internalBuffer)
            .to.contain("solid")
            .and.to.contain("endsolid")
            .and.to.contain("facet")
            .and.to.contain("endfacet")
            .and.to.contain("normal")
            .and.to.contain("vertex")
          done()
        })

        fs.createReadStream(facesListPath, { encoding: "utf-8" })
          .pipe(stlExporter.getTransformStream({ type: "ascii" }))
          .pipe(bufferedStream)
      }))

    it("transforms a polygon-mesh stream to a beautified ascii STL stream", () =>
      new Promise<void>((done) => {
        const bufferedStream = new BufferedStream()
        bufferedStream.on("finish", () => {
          expect(bufferedStream.internalBuffer)
            .to.contain("solid")
            .and.to.contain("endsolid")
            .and.to.contain("facet")
            .and.to.contain("endfacet")
            .and.to.contain("normal")
            .and.to.contain("vertex")
            .and.to.contain("\t")
          done()
        })

        fs.createReadStream(facesListPath, { encoding: "utf-8" })
          .pipe(stlExporter.getTransformStream({ type: "ascii", beautify: true }))
          .pipe(bufferedStream)
      }))
  })
})
