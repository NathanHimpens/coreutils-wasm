# CoreutilsWasm

GNU Coreutils compiled to WebAssembly, wrapped as a Ruby gem.

This gem downloads and runs a WASM binary containing 100+ GNU coreutils commands (`ls`, `cat`, `head`, `tail`, `wc`, `cp`, `mv`, `rm`, etc.) via a WASI runtime like [wasmtime](https://wasmtime.dev/) or [wasmer](https://wasmer.io/).

## Prerequisites

You need a WASI-compatible runtime installed on your system. The gem defaults to `wasmtime`.

```bash
# Option 1: Install wasmtime (default)
curl https://wasmtime.dev/install.sh -sSf | bash

# Option 2: Install wasmer
curl https://get.wasmer.io -sSfL | sh
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coreutils-wasm'
```

Then execute:

```bash
bundle install
```

Or install it yourself:

```bash
gem install coreutils-wasm
```

## Usage

### Quick start

```ruby
require 'coreutils_wasm'

# 1. Download the WASM binary (only needed once)
CoreutilsWasm.download_to_binary_path!

# 2. Run a command
result = CoreutilsWasm.run('ls', '-la', wasm_dir: '.')
puts result[:stdout]
```

### Download the binary

The `.wasm` binary is not bundled with the gem. It is downloaded from GitHub Releases on first use.

```ruby
# Download to the default location (inside the gem directory)
CoreutilsWasm.download_to_binary_path!

# Check if the binary is available
CoreutilsWasm.available?
# => true
```

### Run commands

Once the binary is downloaded, use `run` to execute any coreutils command. Arguments are passed through to the WASM binary.

```ruby
# List files
result = CoreutilsWasm.run('ls', '-la', wasm_dir: '.')
puts result[:stdout]

# Read a file
result = CoreutilsWasm.run('cat', 'Gemfile', wasm_dir: '.')
puts result[:stdout]

# Word count
result = CoreutilsWasm.run('wc', '-l', 'README.md', wasm_dir: '.')
puts result[:stdout]

# Sort input (via file)
result = CoreutilsWasm.run('sort', 'names.txt', wasm_dir: '/path/to/data')
puts result[:stdout]
```

The `run` method returns a hash:

```ruby
{
  stdout:  "...",   # Standard output
  stderr:  "...",   # Standard error
  success: true     # Whether the command succeeded
}
```

The `wasm_dir` parameter controls which host directory is mounted into the WASI sandbox (passed as `--dir` to the runtime). It defaults to `"."`.

### Configuration

```ruby
# Change the path where the .wasm binary is stored
CoreutilsWasm.binary_path = '/opt/wasm/coreutils.wasm'

# Change the WASI runtime (default: "wasmtime")
CoreutilsWasm.runtime = 'wasmer'

# Check the current binary path
CoreutilsWasm.binary_path
# => "/opt/wasm/coreutils.wasm"

# Check the current runtime
CoreutilsWasm.runtime
# => "wasmer"
```

### List available commands

```ruby
CoreutilsWasm.commands
# => ["arch", "base32", "base64", "basename", "cat", "chmod", "cp", "ls", ...]
```

### Error handling

```ruby
# BinaryNotFound -- raised when running before downloading
begin
  CoreutilsWasm.run('ls')
rescue CoreutilsWasm::BinaryNotFound => e
  puts "Binary missing: #{e.message}"
  CoreutilsWasm.download_to_binary_path!
  retry
end

# ExecutionError -- raised on non-zero exit code
begin
  CoreutilsWasm.run('cat', 'nonexistent_file', wasm_dir: '.')
rescue CoreutilsWasm::ExecutionError => e
  puts "Command failed: #{e.message}"
end
```

All errors inherit from `CoreutilsWasm::Error`:

```
StandardError
  └── CoreutilsWasm::Error
        ├── CoreutilsWasm::BinaryNotFound
        └── CoreutilsWasm::ExecutionError
```

## Available Commands

This binary includes all GNU coreutils commands:

`arch`, `base32`, `base64`, `baseenc`, `basename`, `cat`, `chcon`, `chgrp`, `chmod`, `chown`, `chroot`, `cksum`, `comm`, `cp`, `csplit`, `cut`, `date`, `dd`, `df`, `dircolors`, `dirname`, `du`, `echo`, `env`, `expand`, `expr`, `factor`, `false`, `fmt`, `fold`, `groups`, `hashsum`, `head`, `hostid`, `hostname`, `id`, `install`, `join`, `kill`, `link`, `ln`, `logname`, `ls`, `mkdir`, `mkfifo`, `mknod`, `mktemp`, `more`, `mv`, `nice`, `nl`, `nohup`, `nproc`, `numfmt`, `od`, `paste`, `pathchk`, `pinky`, `pr`, `printenv`, `printf`, `ptx`, `pwd`, `readlink`, `realpath`, `relpath`, `rm`, `rmdir`, `runcon`, `seq`, `shred`, `shuf`, `sleep`, `sort`, `split`, `stat`, `stdbuf`, `sum`, `sync`, `tac`, `tail`, `tee`, `test`, `timeout`, `touch`, `tr`, `true`, `truncate`, `tsort`, `tty`, `uname`, `unexpand`, `uniq`, `unlink`, `uptime`, `users`, `wc`, `who`, `whoami`, `yes`

**Note:** `grep` is not included as it's not part of GNU coreutils.

## Development

After checking out the repo, install dependencies:

```bash
cd ruby-gem
bundle install
```

Run the test suite:

```bash
bundle exec rake test
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NathanHimpens/coreutils-wasm.

## License

MIT

## Credits

- [GNU Coreutils](https://www.gnu.org/software/coreutils/)
- [uutils/coreutils](https://github.com/uutils/coreutils) - Rust implementation compiled to WASM
- [Wasmer](https://wasmer.io/) - Original WASM package source
