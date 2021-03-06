require_relative 'lib/mandela/version'

Gem::Specification.new do |spec|
  spec.name          = "mandela"
  spec.version       = Mandela::VERSION
  spec.authors       = ["Abhishek Yadav"]
  spec.email         = ["zerothabhishek@gmail.com"]

  spec.summary       = %q{Mandela}
  spec.description   = %q{Mandela}
  spec.homepage      = "https://mandela.h65.in"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "http://rubygems.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zerothabhishek/mandela"
  spec.metadata["changelog_uri"] = "https://github.com/zerothabhishek/mandela/changelog"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faye-websocket", ">= 0.11"
  spec.add_dependency "permessage_deflate", "0.1.4"
  spec.add_dependency "redis", ">= 4.3"
  spec.add_dependency "concurrent-ruby"
  spec.add_dependency "async"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "puma"
end
