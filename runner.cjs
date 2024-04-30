const day_num = process.argv[2]

const fs = require('fs');
const wasm_bytes = fs.readFileSync(`solutions/${day_num}.wasm`);
const input_bytes = new Uint8Array(fs.readFileSync(`inputs/${day_num}`));

let memory = new WebAssembly.Memory({initial: Math.ceil(input_bytes.length * 4 / 64)});
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
    }
  }
).then(wasm_module => {
  // offset for LF char at the end
  let result = wasm_module.instance.exports.solve(0, input_bytes.length - 1);
  console.log(`Day ${day_num}: ${result}`);
})
