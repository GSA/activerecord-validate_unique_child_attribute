Gem::Specification.new do |s|
  s.name        = 'activerecord-validate_unique_child_attribute'
  s.version     = '0.0.2'
  s.date        = '2015-07-17'
  s.summary     = "Guarantee uniqueness of a single attribute across one or more children of an ActiveRecord object"
  s.description = s.summary + "\n\nWorks around https://github.com/rails/rails/issues/4568"
  s.authors     = ["Nick Marden"]
  s.email       = 'nick@rrsoft.co'
  s.files       = ["lib/active_record/validate_unique_child_attribute.rb"]
  s.homepage    = 'http://github.com/RapidRiverSoftware/activerecord-validate_unique_child_attribute'
  s.license       = 'MIT'

  s.add_runtime_dependency "activerecord",  '>= 3.2.0', '<= 4.2.3'
  s.add_runtime_dependency "activesupport", '>= 3.2.0', '<= 4.2.3'
  s.add_runtime_dependency "activemodel",   '>= 3.2.0', '<= 4.2.3'

  s.add_development_dependency 'appraisal', '= 2.0.2'
  s.add_development_dependency 'rake',      '~> 10.4'
  s.add_development_dependency 'rspec',     '~> 3.0'
  s.add_development_dependency 'rubocop',   '~> 0.32'
end
