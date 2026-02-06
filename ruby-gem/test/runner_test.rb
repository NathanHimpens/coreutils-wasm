# frozen_string_literal: true

require_relative 'test_helper'
require 'open3'

class RunnerTest < Minitest::Test
  include CoreutilsWasmTestHelper

  def test_raises_binary_not_found_when_binary_missing
    Dir.mktmpdir do |dir|
      CoreutilsWasm.binary_path = File.join(dir, 'coreutils.wasm')
      assert_raises(CoreutilsWasm::BinaryNotFound) do
        CoreutilsWasm::Runner.run('ls')
      end
    end
  end

  def test_builds_correct_command_array
    Dir.mktmpdir do |dir|
      binary = File.join(dir, 'coreutils.wasm')
      File.write(binary, 'fake')
      CoreutilsWasm.binary_path = binary

      captured_cmd = nil
      fake_capture3 = lambda do |*cmd|
        captured_cmd = cmd
        status = Minitest::Mock.new
        status.expect(:success?, true)
        ['output', '', status]
      end

      Open3.stub(:capture3, fake_capture3) do
        CoreutilsWasm::Runner.run('ls', '-la')
      end

      assert_equal ['wasmtime', 'run', '--dir', '.', binary, 'ls', '-la'], captured_cmd
    end
  end

  def test_uses_configured_runtime
    Dir.mktmpdir do |dir|
      binary = File.join(dir, 'coreutils.wasm')
      File.write(binary, 'fake')
      CoreutilsWasm.binary_path = binary
      CoreutilsWasm.runtime = 'wasmer'

      captured_cmd = nil
      fake_capture3 = lambda do |*cmd|
        captured_cmd = cmd
        status = Minitest::Mock.new
        status.expect(:success?, true)
        ['', '', status]
      end

      Open3.stub(:capture3, fake_capture3) do
        CoreutilsWasm::Runner.run('echo', 'hello')
      end

      assert_equal 'wasmer', captured_cmd[0]
    end
  end

  def test_returns_success_hash
    Dir.mktmpdir do |dir|
      binary = File.join(dir, 'coreutils.wasm')
      File.write(binary, 'fake')
      CoreutilsWasm.binary_path = binary

      fake_capture3 = lambda do |*_cmd|
        status = Minitest::Mock.new
        status.expect(:success?, true)
        ['hello world', '', status]
      end

      result = nil
      Open3.stub(:capture3, fake_capture3) do
        result = CoreutilsWasm::Runner.run('echo', 'hello world')
      end

      assert_equal({ stdout: 'hello world', stderr: '', success: true }, result)
    end
  end

  def test_raises_execution_error_on_failure
    Dir.mktmpdir do |dir|
      binary = File.join(dir, 'coreutils.wasm')
      File.write(binary, 'fake')
      CoreutilsWasm.binary_path = binary

      fake_capture3 = lambda do |*_cmd|
        status = Minitest::Mock.new
        status.expect(:success?, false)
        status.expect(:exitstatus, 1)
        ['', 'something went wrong', status]
      end

      Open3.stub(:capture3, fake_capture3) do
        err = assert_raises(CoreutilsWasm::ExecutionError) do
          CoreutilsWasm::Runner.run('bad-command')
        end
        assert_match(/something went wrong/, err.message)
      end
    end
  end

  def test_defaults_wasm_dir_to_dot
    Dir.mktmpdir do |dir|
      binary = File.join(dir, 'coreutils.wasm')
      File.write(binary, 'fake')
      CoreutilsWasm.binary_path = binary

      captured_cmd = nil
      fake_capture3 = lambda do |*cmd|
        captured_cmd = cmd
        status = Minitest::Mock.new
        status.expect(:success?, true)
        ['', '', status]
      end

      Open3.stub(:capture3, fake_capture3) do
        CoreutilsWasm::Runner.run('ls')
      end

      assert_equal '.', captured_cmd[3]
    end
  end
end
