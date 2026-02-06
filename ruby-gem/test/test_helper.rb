# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require_relative '../lib/coreutils_wasm'

module CoreutilsWasmTestHelper
  def setup
    @original_binary_path = CoreutilsWasm.instance_variable_get(:@binary_path)
    @original_runtime     = CoreutilsWasm.instance_variable_get(:@runtime)
  end

  def teardown
    CoreutilsWasm.instance_variable_set(:@binary_path, @original_binary_path)
    CoreutilsWasm.instance_variable_set(:@runtime,     @original_runtime)
  end
end
