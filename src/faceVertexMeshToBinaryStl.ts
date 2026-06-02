import writeStringToBufferView from "./helpers/writeStringToBufferView.js"
import type { FaceVertexMesh } from "./types.js"

export default function faceVertexMeshToBinaryStl(
  model: FaceVertexMesh,
): ArrayBuffer {
  const { faceNormalCoordinates, faceVertexIndices, vertexCoordinates, name } =
    model

  // Lengths in byte
  const headerLength = 80 // 80 * uint8
  const facetsCounterLength = 4 // 1 * uint32
  const vectorLength = 12 // 3 * float32
  const attributeByteCountLength = 2 // 1 * uint16
  const facetLength = vectorLength * 4 + attributeByteCountLength
  const contentLength = (faceVertexIndices.length / 3) * facetLength
  const bufferLength = headerLength + facetsCounterLength + contentLength

  const buffer = new ArrayBuffer(bufferLength)
  const headerView = new DataView(buffer, 0, headerLength)
  const dataView = new DataView(buffer, headerLength)
  const le = true // little-endian

  writeStringToBufferView(name, headerView)

  dataView.setUint32(0, faceVertexIndices.length / 3, le)
  let offset = facetsCounterLength

  for (let i = 0; i < faceVertexIndices.length; i += 3) {
    // Normal
    dataView.setFloat32(offset, faceNormalCoordinates[i], le)
    dataView.setFloat32((offset += 4), faceNormalCoordinates[i + 1], le)
    dataView.setFloat32((offset += 4), faceNormalCoordinates[i + 2], le)

    // X,Y,Z-Vector
    for (let a = 0; a <= 2; a++) {
      dataView.setFloat32(
        (offset += 4),
        vertexCoordinates[faceVertexIndices[i + a] * 3],
        le,
      )
      dataView.setFloat32(
        (offset += 4),
        vertexCoordinates[faceVertexIndices[i + a] * 3 + 1],
        le,
      )
      dataView.setFloat32(
        (offset += 4),
        vertexCoordinates[faceVertexIndices[i + a] * 3 + 2],
        le,
      )
    }

    // Attribute Byte Count
    dataView.setUint16((offset += 4), 0, le)
    offset += 2
  }

  return buffer
}
