const day_num = process.argv[2]

const fs = require('fs');
const wasm_bytes = fs.readFileSync(`solutions/${day_num}.wasm`);
const input_bytes = new Uint8Array(fs.readFileSync(`inputs/${day_num}`));

let memory = new WebAssembly.Memory({initial: 2});
let memory_buffer = new Uint8Array(memory.buffer);
for(let i = 0; i < input_bytes.length; i++) {
  memory_buffer[i] = input_bytes[i]
}

WebAssembly.instantiate(
  wasm_bytes,
  {
    env: {
      input: memory,
      debug_func: console.log,
      print_memory_32: (from, len) => {
        const buffer = new Uint32Array(memory.buffer);
        const data = buffer.slice(from, from + len);

        console.log(data);
      }
    }
  }
).then(wasm_module => {
  // offset for LF char at the end
  let part1 = wasm_module.instance.exports.part1(0, input_bytes.length - 1);
  let part2 = wasm_module.instance.exports.part2(0, input_bytes.length - 1);

  console.log(`Day ${day_num}: ${part1}, ${part2}`);
})
