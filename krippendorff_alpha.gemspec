Gem::Specification.new do |s|
  s.name        = 'krippendorff_alpha'
  s.version     = '0.0.2'
  s.date        = '2017-08-30'
  s.summary     = "Krippendorff Alpha implementation"
  s.description = "A Krippendorff Alpha implementation for std-ruby Matrix library"
  s.authors     = ["Brad Folkens"]
  s.email       = 'bfolkens@gmail.com'
  s.files       = %w(krippendorff_alpha.gemspec) + Dir.glob("{lib,spec,ext}/**/*")
  s.license     = 'MIT'
	s.homepage    = 'http://github.com/bfolkens/ruby-krippendorff-alpha'

  s.extensions << 'ext/Rakefile'
  s.extensions << 'ext/mkrf_conf.rb'

  s.add_development_dependency 'minitest', '~> 0'
	s.add_development_dependency 'rake', '~> 0'

  s.add_dependency 'ffi-compiler', '~> 1.0'
end
