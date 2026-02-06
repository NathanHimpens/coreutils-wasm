# frozen_string_literal: true

require 'open3'

module CoreutilsWasm
  class Runner
    class << self
      def run(*args, wasm_dir: '.')
        binary = CoreutilsWasm.binary_path

        raise CoreutilsWasm::BinaryNotFound, "WASM binary not found at #{binary}" unless File.exist?(binary)

        cmd = [
          CoreutilsWasm.runtime,
          'run',
          '--dir', wasm_dir,
          binary,
          *args
        ]

        stdout, stderr, status = Open3.capture3(*cmd)

        unless status.success?
          raise CoreutilsWasm::ExecutionError,
                "Command exited with status #{status.exitstatus}: #{stderr}"
        end

        { stdout: stdout, stderr: stderr, success: true }
      end
    end
  end
end
