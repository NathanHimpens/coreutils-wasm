# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoreutilsWasm do
  describe ".wasm_path" do
    it "returns the path to the WASM binary" do
      expect(CoreutilsWasm.wasm_path).to end_with("wasm/coreutils.wasm")
    end

    it "returns an absolute path" do
      expect(CoreutilsWasm.wasm_path).to start_with("/")
    end
  end

  describe ".wasm_exists?" do
    it "returns true when the WASM file exists" do
      expect(CoreutilsWasm.wasm_exists?).to be true
    end
  end

  describe ".wasm_size" do
    it "returns the file size in bytes" do
      expect(CoreutilsWasm.wasm_size).to be > 1_000_000 # > 1MB
    end
  end

  describe ".wasm_bytes" do
    it "returns binary data" do
      bytes = CoreutilsWasm.wasm_bytes
      expect(bytes).to be_a(String)
      expect(bytes.encoding).to eq(Encoding::ASCII_8BIT)
    end

    it "starts with WASM magic number" do
      bytes = CoreutilsWasm.wasm_bytes
      # WASM files start with \x00asm
      expect(bytes[0..3]).to eq("\x00asm")
    end
  end

  describe ".commands" do
    it "returns an array of command names" do
      expect(CoreutilsWasm.commands).to be_an(Array)
    end

    it "includes common coreutils commands" do
      expect(CoreutilsWasm.commands).to include("ls", "cat", "head", "tail", "wc")
    end

    it "does not include grep (not part of coreutils)" do
      expect(CoreutilsWasm.commands).not_to include("grep")
    end
  end

  describe "VERSION" do
    it "has a version number" do
      expect(CoreutilsWasm::VERSION).not_to be_nil
    end
  end
end
