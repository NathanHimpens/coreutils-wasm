# frozen_string_literal: true

require_relative "lib/coreutils_wasm/version"

Gem::Specification.new do |spec|
  spec.name          = "coreutils-wasm"
  spec.version       = CoreutilsWasm::VERSION
  spec.authors       = ["Nathan Himpens"]
  spec.email         = ["nathan@example.com"]

  spec.summary       = "GNU Coreutils compiled to WebAssembly for Ruby"
  spec.description   = "Provides GNU coreutils commands (ls, cat, head, tail, wc, etc.) " \
                       "running in a WebAssembly sandbox via a WASI runtime (wasmtime, wasmer, etc.)."
  spec.homepage      = "https://github.com/NathanHimpens/coreutils-wasm"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match?(%r{\A(test|spec|features|\.github|patches|agents)/}) ||
      f.match?(%r{\A(\.gitignore|\.rubocop|AGENTS\.md)})
  end
  spec.require_paths = ["lib"]

  # No external runtime dependencies — only Ruby stdlib.

  spec.post_install_message = <<~MSG
    ============================================================
    coreutils-wasm installed!

    The .wasm binary is NOT bundled with this gem.
    Download it on first use:

      require 'coreutils_wasm'
      CoreutilsWasm.download_to_binary_path!

    Or it will be downloaded automatically when needed.
    A WASI runtime (wasmtime, wasmer, etc.) must be installed.
    ============================================================
  MSG

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
