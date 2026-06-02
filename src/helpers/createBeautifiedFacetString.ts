export default function createBeautifiedFacetString(
  vertexCoordinates: number[],
  faceVertexIndices: number[],
  faceNormalCoordinates: number[],
): string {
  let stl = ""

  const stringifyFaceNormal = (index: number): string =>
    `${faceNormalCoordinates[index]} ` +
    `${faceNormalCoordinates[index + 1]} ` +
    `${faceNormalCoordinates[index + 2]}`

  const stringifyVector = (index: number): string =>
    `${vertexCoordinates[index * 3]} ` +
    `${vertexCoordinates[index * 3 + 1]} ` +
    `${vertexCoordinates[index * 3 + 2]}`

  for (let i = 0; i < faceVertexIndices.length; i += 3) {
    stl +=
      "\t" +
      `facet normal ${stringifyFaceNormal(i)}\n` +
      "\t\t" +
      "outer loop\n" +
      "\t\t\t" +
      `vertex ${stringifyVector(faceVertexIndices[i])}\n` +
      "\t\t\t" +
      `vertex ${stringifyVector(faceVertexIndices[i + 1])}\n` +
      "\t\t\t" +
      `vertex ${stringifyVector(faceVertexIndices[i + 2])}\n` +
      "\t\t" +
      "endloop\n" +
      "\t" +
      "endfacet\n"
  }

  return stl
}
