# frozen_string_literal: true

require_relative "coreutils_wasm/version"
require_relative "coreutils_wasm/commands"

# CoreutilsWasm provides GNU coreutils WASM binaries
#
# This gem only provides the WASM binary. You choose how to run it
# with your preferred WebAssembly runtime (wasmer, wasmtime, etc.)
module CoreutilsWasm
  class Error < StandardError; end

  class << self
    # Get the absolute path to the coreutils WASM binary
    # @return [String] Absolute path to coreutils.wasm
    def wasm_path
      @wasm_path ||= File.expand_path("../wasm/coreutils.wasm", __dir__)
    end

    # Get the raw WASM binary as a string of bytes
    # @return [String] Binary string containing the WASM binary
    def wasm_bytes
      File.binread(wasm_path)
    end

    # Get the WASM file size in bytes
    # @return [Integer] Size in bytes
    def wasm_size
      File.size(wasm_path)
    end

    # Check if the WASM binary exists
    # @return [Boolean]
    def wasm_exists?
      File.exist?(wasm_path)
    end

    # List of all available commands in this binary
    # @return [Array<String>]
    def commands
      Commands::ALL
    end
  end
end
