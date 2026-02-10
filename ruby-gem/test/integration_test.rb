# frozen_string_literal: true

require_relative 'test_helper'
require 'open3'

class IntegrationTest < Minitest::Test
  include CoreutilsWasmTestHelper

  def test_full_user_workflow
    Dir.mktmpdir do |dir|
      target = File.join(dir, 'coreutils.wasm')

      # 1. Configure
      CoreutilsWasm.binary_path = target
      CoreutilsWasm.runtime = 'wazero'

      # 2. Not available yet
      refute CoreutilsWasm.available?

      # 3. Download (stub writes fake file)
      CoreutilsWasm::Downloader.stub(:download, ->(to:) { File.write(to, 'fake'); true }) do
        CoreutilsWasm.download_to_binary_path!
      end

      # 4. Now available
      assert CoreutilsWasm.available?

      # 5. Run (stub Open3, capture command)
      captured_cmd = nil
      fake_capture3 = lambda do |*cmd|
        captured_cmd = cmd
        status = Minitest::Mock.new
        status.expect(:success?, true)
        ['', '', status]
      end

      Open3.stub(:capture3, fake_capture3) do
        result = CoreutilsWasm.run('ls', '-la', wasm_dir: dir)
        assert result[:success]
      end

      # 6. Verify command shape (wazero is not wasmer, so uses wasmtime-style --dir)
      assert_equal 'wazero', captured_cmd[0]
      assert_equal 'run', captured_cmd[1]
      assert_equal '--dir', captured_cmd[2]
      assert_equal File.expand_path(dir), captured_cmd[3]
      assert_equal '--', captured_cmd[4]
      assert_equal target, captured_cmd[5]
      assert_equal ['ls', '-la'], captured_cmd[6..]
    end
  end

  def test_run_before_download_raises_binary_not_found
    Dir.mktmpdir do |dir|
      CoreutilsWasm.binary_path = File.join(dir, 'coreutils.wasm')
      assert_raises(CoreutilsWasm::BinaryNotFound) do
        CoreutilsWasm.run('ls', '-la', wasm_dir: dir)
      end
    end
  end
end
