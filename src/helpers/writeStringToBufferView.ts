export default function writeStringToBufferView(
  string: string,
  bufferView: DataView,
): void {
  const stringUint8array = new TextEncoder().encode(string)

  for (let index = 0; index < bufferView.byteLength; index++) {
    bufferView.setUint8(index, stringUint8array[index] || 0)
  }
}
