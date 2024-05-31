This is me practicing WASM using AoC 2017 exercises. To run a `wasm` solution:
```
wat2wasm solutions/<day>.wat -o solutions/<day>.wasm && node runner.cjs <day>
```

Until I got bored of WASM and switched to C. To run the C exercises (from the root of this repo):
```
cc solutions/<day>.c solutions/parsers/*.c -o solution.out && ./solution.out
```
Replace `cc` with your favorite C compiler, if you wish.

