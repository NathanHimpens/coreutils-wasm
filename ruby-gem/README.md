# CoreutilsWasm

GNU Coreutils compiled to WebAssembly.

This gem provides the WASM binary for GNU coreutils. It includes 100+ commands like `ls`, `cat`, `head`, `tail`, `wc`, `cp`, `mv`, `rm`, etc.

**This gem only provides the WASM binary.** You choose how to run it with your preferred WebAssembly runtime.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coreutils-wasm'
```

And then execute:

```bash
bundle install
```

Or install it yourself:

```bash
gem install coreutils-wasm
```

## Usage

### Get the WASM binary path or bytes

```ruby
require 'coreutils_wasm'

# Get the file path (useful for CLI runtimes)
wasm_path = CoreutilsWasm.wasm_path
# => "/path/to/gems/coreutils-wasm-1.0.0/wasm/coreutils.wasm"

# Get as binary string
wasm_bytes = CoreutilsWasm.wasm_bytes

# Get file size
wasm_size = CoreutilsWasm.wasm_size
# => 4705003

# Check if file exists
CoreutilsWasm.wasm_exists?
# => true
```

### List available commands

```ruby
CoreutilsWasm.commands
# => ["arch", "base32", "base64", "basename", "cat", "chmod", "cp", "ls", ...]
```

## Running with different runtimes

### With Wasmer CLI

```bash
# Install wasmer
curl https://get.wasmer.io -sSfL | sh

# Run a command
wasmer run $(ruby -r coreutils_wasm -e "puts CoreutilsWasm.wasm_path") -- ls -la
```

### With Wasmtime CLI

```bash
# Install wasmtime
curl https://wasmtime.dev/install.sh -sSf | bash

# Run a command
wasmtime $(ruby -r coreutils_wasm -e "puts CoreutilsWasm.wasm_path") -- ls -la
```

### With wasmer gem (Ruby runtime)

```ruby
require 'wasmer'
require 'coreutils_wasm'

# Load the WASM binary
wasm_bytes = CoreutilsWasm.wasm_bytes
store = Wasmer::Store.new
module_ = Wasmer::Module.new store, wasm_bytes

# Create WASI environment
wasi_env = Wasmer::Wasi::StateBuilder.new("ls")
  .argument("-la")
  .preopen_directory(".")
  .finalize

# Instantiate with WASI imports
import_object = wasi_env.generate_import_object(store, module_)
instance = Wasmer::Instance.new(module_, import_object)

# Run
wasi_env.start(instance)
```

### With shell execution

```ruby
require 'coreutils_wasm'

# Simple shell execution with wasmer
def run_coreutils(command, *args)
  wasm = CoreutilsWasm.wasm_path
  `wasmer run #{wasm} -- #{command} #{args.join(' ')}`
end

puts run_coreutils('ls', '-la')
puts run_coreutils('cat', 'Gemfile')
```

## Available Commands

This binary includes all GNU coreutils commands:

`arch`, `base32`, `base64`, `baseenc`, `basename`, `cat`, `chcon`, `chgrp`, `chmod`, `chown`, `chroot`, `cksum`, `comm`, `cp`, `csplit`, `cut`, `date`, `dd`, `df`, `dircolors`, `dirname`, `du`, `echo`, `env`, `expand`, `expr`, `factor`, `false`, `fmt`, `fold`, `groups`, `hashsum`, `head`, `hostid`, `hostname`, `id`, `install`, `join`, `kill`, `link`, `ln`, `logname`, `ls`, `mkdir`, `mkfifo`, `mknod`, `mktemp`, `more`, `mv`, `nice`, `nl`, `nohup`, `nproc`, `numfmt`, `od`, `paste`, `pathchk`, `pinky`, `pr`, `printenv`, `printf`, `ptx`, `pwd`, `readlink`, `realpath`, `relpath`, `rm`, `rmdir`, `runcon`, `seq`, `shred`, `shuf`, `sleep`, `sort`, `split`, `stat`, `stdbuf`, `sum`, `sync`, `tac`, `tail`, `tee`, `test`, `timeout`, `touch`, `tr`, `true`, `truncate`, `tsort`, `tty`, `uname`, `unexpand`, `uniq`, `unlink`, `uptime`, `users`, `wc`, `who`, `whoami`, `yes`

**Note:** `grep` is not included as it's not part of GNU coreutils.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NathanHimpens/coreutils-wasm.

## License

MIT

## Credits

- [GNU Coreutils](https://www.gnu.org/software/coreutils/)
- [uutils/coreutils](https://github.com/uutils/coreutils) - Rust implementation compiled to WASM
- [Wasmer](https://wasmer.io/) - Original WASM package source
