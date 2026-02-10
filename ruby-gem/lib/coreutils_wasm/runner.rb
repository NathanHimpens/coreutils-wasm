# frozen_string_literal: true

require 'open3'

module CoreutilsWasm
  class Runner
    class << self
      def run(*args, wasm_dir: '.')
        binary = CoreutilsWasm.binary_path

        raise CoreutilsWasm::BinaryNotFound, "WASM binary not found at #{binary}" unless File.exist?(binary)

        expanded_dir = File.expand_path(wasm_dir)

        cmd = build_command(binary, expanded_dir, args)

        stdout, stderr, status = Open3.capture3(*cmd)

        unless status.success?
          raise CoreutilsWasm::ExecutionError,
                "Command exited with status #{status.exitstatus}: #{stderr}"
        end

        { stdout: stdout, stderr: stderr, success: true }
      end

      private

      def build_command(binary, expanded_dir, args)
        runtime = CoreutilsWasm.runtime

        if runtime.include?('wasmer')
          [
            runtime,
            'run',
            '--volume', expanded_dir,
            binary,
            '--',
            *args
          ]
        else
          [
            runtime,
            'run',
            '--dir', expanded_dir,
            '--',
            binary,
            *args
          ]
        end
      end
    end
  end
end
