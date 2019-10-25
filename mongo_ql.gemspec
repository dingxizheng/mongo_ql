# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mongo_ql/version"

Gem::Specification.new do |spec|
  spec.name          = "mongo_ql"
  spec.version       = MongoQL::VERSION
  spec.authors       = ["Xizheng Ding"]
  spec.email         = ["dingxizheng@gamil.com"]

  spec.summary       = "A DSL for building mongo query in a more natual way"
  spec.homepage      = "https://github.com/dingxizheng/mongo_ql"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end