import createFacetString from "./helpers/createFacetString.js"
import createBeautifiedFacetString from "./helpers/createBeautifiedFacetString.js"
import type { FaceVertexMesh } from "./types.js"

export interface AsciiStlOptions {
  beautify?: boolean
  fileName?: string
}

export default function faceVertexMeshToAsciiStl(
  model: FaceVertexMesh,
  options: AsciiStlOptions = {},
): string {
  const beautify = options.beautify ?? false

  const { faceNormalCoordinates, faceVertexIndices, vertexCoordinates, name } =
    model

  let stl = `solid ${name}\n`

  stl += beautify
    ? createBeautifiedFacetString(
        vertexCoordinates,
        faceVertexIndices,
        faceNormalCoordinates,
      )
    : createFacetString(
        vertexCoordinates,
        faceVertexIndices,
        faceNormalCoordinates,
      )

  stl += `endsolid ${name}\n`

  return stl
}
