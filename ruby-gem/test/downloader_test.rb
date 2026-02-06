# frozen_string_literal: true

require_relative 'test_helper'

class DownloaderTest < Minitest::Test
  include CoreutilsWasmTestHelper

  def test_repo_owner_constant_defined
    assert_equal 'NathanHimpens', CoreutilsWasm::Downloader::REPO_OWNER
  end

  def test_repo_name_constant_defined
    assert_equal 'coreutils-wasm', CoreutilsWasm::Downloader::REPO_NAME
  end

  def test_asset_name_constant_defined
    assert_equal 'coreutils.wasm', CoreutilsWasm::Downloader::ASSET_NAME
  end

  def test_download_accepts_to_keyword
    # Verify the method signature accepts `to:` by stubbing internals
    CoreutilsWasm::Downloader.stub(:get_latest_release_tag, 'v1.0.0') do
      CoreutilsWasm::Downloader.stub(:download_asset, ->(_tag, target) { File.write(target, 'fake') }) do
        Dir.mktmpdir do |dir|
          target = File.join(dir, 'coreutils.wasm')
          result = CoreutilsWasm::Downloader.download(to: target)
          assert result
        end
      end
    end
  end

  def test_download_raises_on_network_error
    CoreutilsWasm::Downloader.stub(:get_latest_release_tag, -> { raise StandardError, 'network error' }) do
      Dir.mktmpdir do |dir|
        target = File.join(dir, 'coreutils.wasm')
        assert_raises(StandardError) do
          CoreutilsWasm::Downloader.download(to: target)
        end
        # Partial file should be cleaned up
        refute File.exist?(target)
      end
    end
  end

  def test_download_expands_target_path
    expanded_target = nil
    CoreutilsWasm::Downloader.stub(:get_latest_release_tag, 'v1.0.0') do
      CoreutilsWasm::Downloader.stub(:download_asset, lambda { |_tag, target|
        expanded_target = target
        File.write(target, 'fake')
      }) do
        Dir.mktmpdir do |dir|
          relative = File.join(dir, '..', File.basename(dir), 'coreutils.wasm')
          CoreutilsWasm::Downloader.download(to: relative)
          assert_equal File.expand_path(relative), expanded_target
        end
      end
    end
  end

  def test_download_returns_true_on_success
    CoreutilsWasm::Downloader.stub(:get_latest_release_tag, 'v1.0.0') do
      CoreutilsWasm::Downloader.stub(:download_asset, ->(_tag, target) { File.write(target, 'fake') }) do
        Dir.mktmpdir do |dir|
          target = File.join(dir, 'coreutils.wasm')
          result = CoreutilsWasm::Downloader.download(to: target)
          assert_equal true, result
        end
      end
    end
  end
end
