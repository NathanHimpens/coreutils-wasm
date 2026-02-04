# @nathanhimpens/coreutils-wasm

GNU Coreutils compiled to WebAssembly.

This package provides the WASM binary for GNU coreutils. It includes 100+ commands like `ls`, `cat`, `head`, `tail`, `wc`, `cp`, `mv`, `rm`, etc.

**This package only provides the WASM binary.** You choose how to run it with your preferred WebAssembly runtime.

## Installation

```bash
npm install @nathanhimpens/coreutils-wasm
```

## Usage

### Get the WASM binary path or bytes

```javascript
import { getWasmPath, getWasmBytes, getWasmUint8Array } from '@nathanhimpens/coreutils-wasm';

// Get the file path (useful for CLI runtimes)
const wasmPath = getWasmPath();
// => "/path/to/node_modules/@nathanhimpens/coreutils-wasm/wasm/coreutils.wasm"

// Get as Buffer
const wasmBuffer = getWasmBytes();

// Get as Uint8Array (for WebAssembly.compile)
const wasmArray = getWasmUint8Array();
```

### Direct import of the WASM file

```javascript
// Import path directly
import wasmPath from '@nathanhimpens/coreutils-wasm/wasm';
```

### List available commands

```javascript
import { commands } from '@nathanhimpens/coreutils-wasm';
console.log(commands);
// ['arch', 'base32', 'base64', 'basename', 'cat', 'chmod', 'cp', 'ls', ...]
```

## Running with different runtimes

### With Wasmer CLI

```bash
# Install wasmer
curl https://get.wasmer.io -sSfL | sh

# Run a command
wasmer run $(node -e "console.log(require('@nathanhimpens/coreutils-wasm').getWasmPath())") -- ls -la
```

### With Wasmtime CLI

```bash
# Install wasmtime
curl https://wasmtime.dev/install.sh -sSf | bash

# Run a command
wasmtime $(node -e "console.log(require('@nathanhimpens/coreutils-wasm').getWasmPath())") -- ls -la
```

### With @wasmer/sdk (in Node.js)

```javascript
import { init, Wasmer } from '@wasmer/sdk';
import { getWasmBytes } from '@nathanhimpens/coreutils-wasm';

await init();

const wasm = getWasmBytes();
const module = await WebAssembly.compile(wasm);
// ... use with Wasmer SDK
```

### With Node.js built-in WASI (Node 18+)

```javascript
import { WASI } from 'wasi';
import { getWasmUint8Array } from '@nathanhimpens/coreutils-wasm';

const wasi = new WASI({
  version: 'preview1',
  args: ['ls', '-la'],
  preopens: { '.': '.' }
});

const wasm = getWasmUint8Array();
const module = await WebAssembly.compile(wasm);
const instance = await WebAssembly.instantiate(module, wasi.getImportObject());
wasi.start(instance);
```

## Available Commands

This binary includes all GNU coreutils commands:

`arch`, `base32`, `base64`, `baseenc`, `basename`, `cat`, `chcon`, `chgrp`, `chmod`, `chown`, `chroot`, `cksum`, `comm`, `cp`, `csplit`, `cut`, `date`, `dd`, `df`, `dircolors`, `dirname`, `du`, `echo`, `env`, `expand`, `expr`, `factor`, `false`, `fmt`, `fold`, `groups`, `hashsum`, `head`, `hostid`, `hostname`, `id`, `install`, `join`, `kill`, `link`, `ln`, `logname`, `ls`, `mkdir`, `mkfifo`, `mknod`, `mktemp`, `more`, `mv`, `nice`, `nl`, `nohup`, `nproc`, `numfmt`, `od`, `paste`, `pathchk`, `pinky`, `pr`, `printenv`, `printf`, `ptx`, `pwd`, `readlink`, `realpath`, `relpath`, `rm`, `rmdir`, `runcon`, `seq`, `shred`, `shuf`, `sleep`, `sort`, `split`, `stat`, `stdbuf`, `sum`, `sync`, `tac`, `tail`, `tee`, `test`, `timeout`, `touch`, `tr`, `true`, `truncate`, `tsort`, `tty`, `uname`, `unexpand`, `uniq`, `unlink`, `uptime`, `users`, `wc`, `who`, `whoami`, `yes`

**Note:** `grep` is not included as it's not part of GNU coreutils.

## License

MIT

## Credits

- [GNU Coreutils](https://www.gnu.org/software/coreutils/)
- [uutils/coreutils](https://github.com/uutils/coreutils) - Rust implementation compiled to WASM
- [Wasmer](https://wasmer.io/) - Original WASM package source
