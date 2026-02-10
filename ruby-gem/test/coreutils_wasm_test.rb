# frozen_string_literal: true

require_relative 'test_helper'

class CoreutilsWasmTest < Minitest::Test
  include CoreutilsWasmTestHelper

  def test_binary_path_returns_default_when_not_configured
    assert_match %r{lib/coreutils_wasm/coreutils\.wasm\z}, CoreutilsWasm.binary_path
  end

  def test_binary_path_setter_overrides_path
    CoreutilsWasm.binary_path = '/tmp/custom.wasm'
    assert_equal '/tmp/custom.wasm', CoreutilsWasm.binary_path
  end

  def test_runtime_returns_wasmer_by_default
    assert_equal 'wasmer', CoreutilsWasm.runtime
  end

  def test_runtime_setter_overrides_runtime
    CoreutilsWasm.runtime = 'wasmer'
    assert_equal 'wasmer', CoreutilsWasm.runtime
  end

  def test_available_returns_false_when_binary_missing
    CoreutilsWasm.binary_path = '/tmp/nonexistent_binary.wasm'
    refute CoreutilsWasm.available?
  end

  def test_available_returns_true_when_binary_exists
    Dir.mktmpdir do |dir|
      binary = File.join(dir, 'coreutils.wasm')
      File.write(binary, 'fake')
      CoreutilsWasm.binary_path = binary
      assert CoreutilsWasm.available?
    end
  end

  def test_error_class_hierarchy
    assert CoreutilsWasm::BinaryNotFound < CoreutilsWasm::Error
    assert CoreutilsWasm::Error < StandardError
  end

  def test_execution_error_class_hierarchy
    assert CoreutilsWasm::ExecutionError < CoreutilsWasm::Error
  end

  def test_version_matches_semver
    assert_match(/\A\d+\.\d+\.\d+\z/, CoreutilsWasm::VERSION)
  end

  def test_download_to_binary_path_delegates_to_downloader
    called_with = nil
    CoreutilsWasm::Downloader.stub(:download, ->(to:) { called_with = to; true }) do
      CoreutilsWasm.download_to_binary_path!
    end
    assert_equal CoreutilsWasm.binary_path, called_with
  end

  def test_run_delegates_to_runner
    called_args = nil
    called_kwargs = nil
    fake_run = lambda do |*args, wasm_dir: '.'|
      called_args = args
      called_kwargs = { wasm_dir: wasm_dir }
      { stdout: '', stderr: '', success: true }
    end

    CoreutilsWasm::Runner.stub(:run, fake_run) do
      CoreutilsWasm.run('--help', wasm_dir: '/tmp')
    end

    assert_equal ['--help'], called_args
    assert_equal({ wasm_dir: '/tmp' }, called_kwargs)
  end

  def test_commands_returns_array_of_strings
    assert_kind_of Array, CoreutilsWasm.commands
    assert CoreutilsWasm.commands.all? { |c| c.is_a?(String) }
  end

  def test_commands_includes_common_coreutils
    %w[ls cat head tail wc cp mv rm].each do |cmd|
      assert_includes CoreutilsWasm.commands, cmd
    end
  end
end
