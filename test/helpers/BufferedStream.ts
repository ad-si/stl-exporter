import { Writable } from "node:stream"
import type { WritableOptions } from "node:stream"

export default class BufferedStream extends Writable {
  internalBuffer: string

  constructor(options: WritableOptions = {}) {
    options.objectMode = true
    super(options)
    this.internalBuffer = ""
  }

  override _write(
    chunk: unknown,
    _encoding: BufferEncoding,
    done: (error?: Error | null) => void,
  ): void {
    this.internalBuffer += chunk
    done()
  }
}
