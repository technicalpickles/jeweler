# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jeweler}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Nichols"]
  s.date = %q{2008-11-15}
  s.default_executable = %q{jeweler}
  s.description = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}
  s.email = %q{josh@technicalpickles.com}
  s.executables = ["jeweler"]
  s.files = ["README.markdown", "Rakefile", "TODO", "VERSION.yml", "bin/jeweler", "lib/jeweler.rb", "lib/jeweler", "lib/jeweler/bumping.rb", "lib/jeweler/errors.rb", "lib/jeweler/gemspec.rb", "lib/jeweler/release.rb", "lib/jeweler/tasks.rb", "lib/jeweler/templates", "lib/jeweler/templates/LICENSE", "lib/jeweler/templates/README", "lib/jeweler/templates/test", "lib/jeweler/templates/test/flunking_test.rb", "lib/jeweler/templates/test/test_helper.rb", "lib/jeweler/templates/spec", "lib/jeweler/templates/spec/spec_helper.rb", "lib/jeweler/templates/spec/flunking_spec.rb", "lib/jeweler/templates/Rakefile", "lib/jeweler/versioning.rb", "lib/jeweler/generator.rb", "test/fixtures", "test/fixtures/bar", "test/fixtures/bar/VERSION.yml", "test/jeweler_test.rb", "test/test_helper.rb", "test/jeweler_generator_test.rb", "lib/jeweler/templates/.gitignore"]
  s.homepage = %q{http://github.com/technicalpickles/jeweler}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<schacon-git>, [">= 0"])
    else
      s.add_dependency(%q<schacon-git>, [">= 0"])
    end
  else
    s.add_dependency(%q<schacon-git>, [">= 0"])
  end
end
