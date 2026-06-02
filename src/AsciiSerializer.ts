import { Transform } from "node:stream"
import type { TransformCallback, TransformOptions } from "node:stream"
import type { Face } from "./types.js"

function createFacetString(face: Face): string {
  const { normal, vertices } = face

  return (
    `facet normal ${normal.x} ${normal.y} ${normal.z}\n` +
    "outer loop\n" +
    `vertex ${vertices[0].x} ${vertices[0].y} ${vertices[0].z}\n` +
    `vertex ${vertices[1].x} ${vertices[1].y} ${vertices[1].z}\n` +
    `vertex ${vertices[2].x} ${vertices[2].y} ${vertices[2].z}\n` +
    "endloop\n" +
    "endfacet\n"
  )
}

function createBeautifiedFacetString(face: Face): string {
  const { normal, vertices } = face

  return (
    `facet normal ${normal.x} ${normal.y} ${normal.z}\n` +
    "\touter loop\n" +
    `\t\tvertex ${vertices[0].x} ${vertices[0].y} ${vertices[0].z}\n` +
    `\t\tvertex ${vertices[1].x} ${vertices[1].y} ${vertices[1].z}\n` +
    `\t\tvertex ${vertices[2].x} ${vertices[2].y} ${vertices[2].z}\n` +
    "\tendloop\n" +
    "endfacet\n"
  )
}

export interface SerializerOptions extends TransformOptions {
  beautify?: boolean
}

export default class AsciiSerializer extends Transform {
  private options: SerializerOptions
  private internalBuffer: string[]
  private name: string

  constructor(options: SerializerOptions = {}) {
    options.writableObjectMode ??= true
    options.readableObjectMode ??= false
    super(options)

    this.options = options
    this.internalBuffer = []
    this.name = ""
  }

  override _flush(done: TransformCallback): void {
    this.push(`endsolid ${this.name}\n`)
    done()
  }

  override _transform(
    chunk: unknown,
    _encoding: BufferEncoding,
    done: TransformCallback,
  ): void {
    this.internalBuffer = this.internalBuffer.concat(String(chunk).split("\n"))

    let line: string | undefined
    while ((line = this.internalBuffer.shift())) {
      const data = JSON.parse(line)

      if (Object.hasOwn(data, "name")) {
        this.name = data.name
        this.push(`solid ${this.name}\n`)
        continue
      }

      if (Object.hasOwn(data, "vertices")) {
        this.push(
          this.options.beautify
            ? createBeautifiedFacetString(data)
            : createFacetString(data),
        )
      }
    }

    done()
  }
}
