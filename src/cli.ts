import fs from "node:fs"
import path from "node:path"
import process from "node:process"

import yaml from "js-yaml"

import { toAsciiStl, toBinaryStl, getTransformStream } from "./index.js"
import type { FaceVertexMesh } from "./types.js"

export function run(): void {
  const args = process.argv.slice(2)
  const flags: Record<string, boolean> = {}

  for (const cliArgument of args) {
    if (/^--/i.test(cliArgument)) {
      flags[cliArgument.slice(2)] = true
    }
  }

  if (process.stdin.isTTY) {
    if (!args.length) {
      console.log(
        `Usage: ${path.basename(process.argv[1])} ` +
          "[--ascii (default)| --binary] <json mesh-file>",
      )
      process.exit(1)
      return
    }

    let filePath = args[args.length - 1]

    if (!path.isAbsolute(filePath)) {
      filePath = path.join(process.cwd(), filePath)
    }

    const jsonStl = yaml.load(
      fs.readFileSync(filePath, "utf-8"),
    ) as FaceVertexMesh

    const output: string | Buffer = flags.binary
      ? Buffer.from(toBinaryStl(jsonStl))
      : toAsciiStl(jsonStl)

    process.stdout.write(output)
  } else {
    process.stdin.setEncoding("utf-8")

    process.stdin
      .pipe(getTransformStream({ type: flags.binary ? "binary" : "ascii" }))
      .pipe(process.stdout)
  }
}
