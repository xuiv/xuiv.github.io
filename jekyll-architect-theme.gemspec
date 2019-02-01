# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "xuiv's pages"
  spec.version       = "0.1.0"
  spec.authors       = ["xuiv"]
  spec.email         = ["xuiv01@gmail.com"]

  spec.summary       = %q{记录页}
  spec.homepage      = "https://pages.xuiv.ga"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(_layouts|_includes|_sass|LICENSE|README)/i}) }

  spec.add_development_dependency "jekyll", "~> 3.2"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
