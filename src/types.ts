export interface Vector3 {
  x: number
  y: number
  z: number
}

export interface Face {
  normal: Vector3
  vertices: Vector3[]
}

export interface FaceVertexMesh {
  name: string
  vertexCoordinates: number[]
  faceVertexIndices: number[]
  faceNormalCoordinates: number[]
}
