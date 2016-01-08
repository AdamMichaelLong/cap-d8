Gem::Specification.new do |s|
  s.name = %q{cap-drupal8}
  s.version = "0.1.5"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Long"]
  s.date = %q{2016-01-08}
  s.description = %q{A set of tasks for deploying Drupal8 projects with Capistrano}
  s.email = %q{adam.michael.long@gmail.com}
  s.files = [
    "cap-drupal8.gemspec",
    "lib/cap-drupal8.rb"
  ]
  s.homepage = %q{https://github.com/AdamMichaelLong/cap-drupal8/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A set of tasks for deploying Drupal8 projects with Capistrano}
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

