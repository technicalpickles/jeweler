Gem::Specification.new do |s|
  s.name = %q{jeweler}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Nichols", "Dan Croak"]
  s.date = %q{2008-10-12}
  s.description = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}
  s.email = %q{josh@technicalpickles.com}
  s.files = ["Rakefile", "README.markdown", "TODO", "lib/jeweler", "lib/jeweler/active_support.rb", "lib/jeweler/bumping.rb", "lib/jeweler/errors.rb", "lib/jeweler/gemspec.rb", "lib/jeweler/singleton.rb", "lib/jeweler/tasks.rb", "lib/jeweler/version.rb", "lib/jeweler/versioning.rb", "lib/jeweler.rb", "test/jeweler_test.rb", "test/test_helper.rb"]
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
