# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'mycnf'
  spec.version       = '0.0.1'
  spec.authors       = ['studio3104']
  spec.email         = ['studio3104.com@gmail.com']

  spec.summary       = %q{parser of my.cnf}
  spec.description   = %q{parser of my.cnf}
  spec.homepage      = 'https://github.com/studio3104/mycnf'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'test-unit'
end
