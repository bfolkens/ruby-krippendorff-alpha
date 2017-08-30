Gem::Specification.new do |s|
  s.name        = 'krippendorff_alpha'
  s.version     = '0.0.3'
  s.date        = '2017-08-30'
  s.summary     = 'Krippendorff Alpha implementation'
  s.description = 'A Krippendorff Alpha implementation for std-ruby Matrix library'
  s.authors     = ['Brad Folkens']
  s.email       = 'bfolkens@gmail.com'
  s.files       = %w(krippendorff_alpha.gemspec) + Dir.glob('{lib,spec,ext}/**/*')
  s.license     = 'MIT'
	s.homepage    = 'http://github.com/bfolkens/ruby-krippendorff-alpha'

  s.extensions << 'ext/Rakefile'

  s.add_development_dependency 'minitest', '~> 5.9'
	s.add_development_dependency 'rake', '~> 11.2'

  s.add_dependency 'ffi-compiler', '~> 1.0'
end
