import { Transform } from "node:stream"
import type { TransformCallback, TransformOptions } from "node:stream"
import writeStringToBufferView from "./helpers/writeStringToBufferView.js"
import type { Face } from "./types.js"

export interface BinarySerializerOptions extends TransformOptions {
  beautify?: boolean
}

export default class BinarySerializer extends Transform {
  private internalBuffer: string[]
  private name: string

  // Lengths in byte
  private headerLength = 80 // 80 * uint8
  private facetsCounterLength = 4 // 1 * uint32
  private vectorLength = 12 // 3 * float32
  private attributeByteCountLength = 2 // 1 * uint16
  private facetLength = this.vectorLength * 4 + this.attributeByteCountLength
  private littleEndian = true

  constructor(options: BinarySerializerOptions = {}) {
    options.writableObjectMode ??= true
    options.readableObjectMode ??= false
    super(options)

    this.internalBuffer = []
    this.name = ""
  }

  private createFacetBuffer(face: Face): Buffer {
    const { normal, vertices } = face

    const arrayBuffer = new ArrayBuffer(this.facetLength)
    const dataView = new DataView(arrayBuffer)
    let offset = 0

    // Normal
    dataView.setFloat32(offset, normal.x, this.littleEndian)
    dataView.setFloat32((offset += 4), normal.y, this.littleEndian)
    dataView.setFloat32((offset += 4), normal.z, this.littleEndian)

    // X,Y,Z-Vector
    for (let index = 0; index <= 2; index++) {
      dataView.setFloat32((offset += 4), vertices[index].x, this.littleEndian)
      dataView.setFloat32((offset += 4), vertices[index].y, this.littleEndian)
      dataView.setFloat32((offset += 4), vertices[index].z, this.littleEndian)
    }

    // Attribute Byte Count
    dataView.setUint16((offset += 4), 0, this.littleEndian)
    offset += 2

    return Buffer.from(arrayBuffer)
  }

  override _flush(done: TransformCallback): void {
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

        const arrayBuffer = new ArrayBuffer(
          this.headerLength + this.facetsCounterLength,
        )
        const headerView = new DataView(arrayBuffer, 0, this.headerLength)
        const dataView = new DataView(arrayBuffer, this.headerLength)

        writeStringToBufferView(this.name, headerView)

        // Set facets-counter
        dataView.setUint32(0, data.faceCount || 0, this.littleEndian)

        this.push(Buffer.from(arrayBuffer))

        continue
      }

      if (Object.hasOwn(data, "vertices")) {
        this.push(this.createFacetBuffer(data))
      }
    }

    done()
  }
}
