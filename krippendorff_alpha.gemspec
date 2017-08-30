Gem::Specification.new do |s|
  s.name        = 'krippendorff_alpha'
  s.version     = '0.0.1'
  s.date        = '2016-11-05'
  s.summary     = "Krippendorff Alpha implementation"
  s.description = "A Krippendorff Alpha implementation for std-ruby Matrix library"
  s.authors     = ["Brad Folkens"]
  s.email       = 'bfolkens@gmail.com'
  s.files       = %w(krippendorff_alpha.gemspec) + Dir.glob("{lib,spec,ext}/**/*")
  s.license     = 'MIT'

  s.extensions << 'ext/Rakefile'
  s.extensions << 'ext/mkrf_conf.rb'

  s.add_development_dependency 'minitest'

  s.add_dependency 'rake'
  s.add_dependency 'ffi-compiler'
end
