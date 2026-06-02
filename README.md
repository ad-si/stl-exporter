# STL-Exporter

STL-exporter lets you convert array based representations of 3D models like
face-vertex-meshes or polygon-meshes as used by [meshlib](http://github.com/Lowfab/meshlib) to binary and ascii-STLs.

## Installation

```sh
npm install stl-exporter
```

## Usage

### Library (ESM)

```ts
import { toAsciiStl, toBinaryStl, getTransformStream } from "stl-exporter"

// Convert a face-vertex mesh to an ASCII STL string
const ascii = toAsciiStl(mesh, { beautify: true })

// Convert a face-vertex mesh to a binary STL (ArrayBuffer)
const binary = toBinaryStl(mesh)

// Stream a polygon-mesh (JSONL) to an STL stream
import { createReadStream } from "node:fs"
createReadStream("mesh.jsonl", { encoding: "utf-8" })
  .pipe(getTransformStream({ type: "ascii" }))
  .pipe(process.stdout)
```

### CLI

```sh
stl-exporter [--ascii (default) | --binary] <json mesh-file>
```

## Development

This is an ESM TypeScript project.

```sh
npm install      # install dependencies (runs the build)
npm run build    # compile src/ to dist/
npm run typecheck
npm test         # run the test suite (vitest)
```
