# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "coreutils-wasm"
  spec.version       = "1.0.0"
  spec.authors       = ["Nathan Himpens"]
  spec.email         = ["nathan@example.com"]

  spec.summary       = "GNU Coreutils compiled to WebAssembly for Ruby"
  spec.description   = "Provides GNU coreutils commands (ls, cat, head, tail, wc, etc.) " \
                       "running in a WebAssembly sandbox via Wasmer CLI."
  spec.homepage      = "https://github.com/NathanHimpens/coreutils-wasm"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem
  spec.files = Dir[
    "lib/**/*",
    "wasm/**/*",
    "LICENSE",
    "README.md",
    "CHANGELOG.md"
  ]
  spec.require_paths = ["lib"]

  # No runtime dependencies - uses Wasmer CLI which must be installed separately

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
end
