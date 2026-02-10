# frozen_string_literal: true

require_relative 'coreutils_wasm/version'
require_relative 'coreutils_wasm/downloader'
require_relative 'coreutils_wasm/runner'
require_relative 'coreutils_wasm/commands'

module CoreutilsWasm
  class Error < StandardError; end
  class BinaryNotFound < Error; end
  class ExecutionError < Error; end

  DEFAULT_BINARY_PATH = File.join(File.dirname(__FILE__), 'coreutils_wasm', 'coreutils.wasm').freeze

  class << self
    attr_writer :binary_path, :runtime

    def binary_path
      @binary_path || DEFAULT_BINARY_PATH
    end

    def runtime
      @runtime || 'wasmer'
    end

    def download_to_binary_path!
      Downloader.download(to: binary_path)
    end

    def run(*args, wasm_dir: '.')
      Runner.run(*args, wasm_dir: wasm_dir)
    end

    def available?
      File.exist?(binary_path)
    end

    # List of all available commands in this binary (coreutils-specific convenience)
    # @return [Array<String>]
    def commands
      Commands::ALL
    end
  end
end
