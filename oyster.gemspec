Gem::Specification.new do |s|
  s.name              = "oyster"
  s.version           = "0.9.5"
  s.summary           = "Command-line input parser that doesn't hate you"
  s.author            = "James Coglan"
  s.email             = "jcoglan@gmail.com"
  s.homepage          = "http://github.com/jcoglan/oyster"

  s.extra_rdoc_files  = %w[README.rdoc]
  s.rdoc_options      = %w[--main README.rdoc]

  s.files             = %w[History.txt README.rdoc] + Dir.glob("{lib,test}/**/*")
  s.require_paths     = ["lib"]

  s.add_development_dependency "test-unit"
end
