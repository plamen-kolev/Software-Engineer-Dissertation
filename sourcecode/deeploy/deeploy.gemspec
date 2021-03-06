# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deeploy/version'

Gem::Specification.new do |spec|
  spec.name          = "deeploy"
  spec.version       = Deeploy::VERSION
  spec.authors       = ["Plamen Kolev"]
  spec.email         = ["p.kolev22@gmail.com"]

  spec.summary       = %q{a}
  spec.description   = %q{a}
  spec.homepage      = "http://google.com"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  
  spec.add_runtime_dependency "figaro", '~> 1.1'
  spec.add_runtime_dependency 'net-ssh', '~> 4.1'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "figaro", '~> 1.1'
  # spec.add_development_dependency "minitest", "~> 2.0"
  spec.add_development_dependency 'activerecord', '~> 5.0', '>= 5.0.1'
  spec.add_development_dependency 'bcrypt', '~> 3.1', '>= 3.1.11'
  spec.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'
end
