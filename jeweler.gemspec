Gem::Specification.new do |s|
  s.name = %q{jeweler}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Nichols"]
  s.date = %q{2008-10-11}
  s.description = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}
  s.email = %q{josh@technicalpickles.com}
  s.files = ["Rakefile", "README.markdown", "lib/jeweler", "lib/jeweler/tasks.rb", "lib/jeweler/version.rb", "lib/jeweler.rb"]
  s.homepage = %q{http://github.com/technicalpickles/jeweler}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
