import type { Transform } from "node:stream"
import faceVertexMeshToAsciiStl from "./faceVertexMeshToAsciiStl.js"
import faceVertexMeshToBinaryStl from "./faceVertexMeshToBinaryStl.js"
import AsciiSerializer from "./AsciiSerializer.js"
import BinarySerializer from "./BinarySerializer.js"

export const toAsciiStl = faceVertexMeshToAsciiStl
export const toBinaryStl = faceVertexMeshToBinaryStl

export { AsciiSerializer, BinarySerializer }
export type { FaceVertexMesh, Face, Vector3 } from "./types.js"
export type { AsciiStlOptions } from "./faceVertexMeshToAsciiStl.js"

export interface TransformStreamOptions {
  type?: "ascii" | "binary"
  beautify?: boolean
}

export function getTransformStream(
  options: TransformStreamOptions = {},
): Transform {
  const type = options.type ?? "binary"

  if (type === "binary") {
    return new BinarySerializer(options)
  }

  if (type === "ascii") {
    return new AsciiSerializer(options)
  }

  throw new Error(`Options type ${type} is not supported`)
}

export default {
  toAsciiStl,
  toBinaryStl,
  getTransformStream,
}
