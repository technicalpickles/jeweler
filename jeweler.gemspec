# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jeweler}
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Nichols"]
  s.date = %q{2009-03-07}
  s.default_executable = %q{jeweler}
  s.description = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}
  s.email = %q{josh@technicalpickles.com}
  s.executables = ["jeweler"]
  s.extra_rdoc_files = ["README.markdown", "ChangeLog.markdown", "LICENSE"]
  s.files = ["ChangeLog.markdown", "LICENSE", "Rakefile", "README.markdown", "TODO", "VERSION.yml", "bin/jeweler", "lib/jeweler", "lib/jeweler/commands", "lib/jeweler/commands/build_gem.rb", "lib/jeweler/commands/install_gem.rb", "lib/jeweler/commands/release.rb", "lib/jeweler/commands/release_to_rubyforge.rb", "lib/jeweler/commands/validate_gemspec.rb", "lib/jeweler/commands/version", "lib/jeweler/commands/version/base.rb", "lib/jeweler/commands/version/bump_major.rb", "lib/jeweler/commands/version/bump_minor.rb", "lib/jeweler/commands/version/bump_patch.rb", "lib/jeweler/commands/version/write.rb", "lib/jeweler/commands/write_gemspec.rb", "lib/jeweler/commands.rb", "lib/jeweler/errors.rb", "lib/jeweler/gemspec_helper.rb", "lib/jeweler/generator", "lib/jeweler/generator/application.rb", "lib/jeweler/generator/options.rb", "lib/jeweler/generator.rb", "lib/jeweler/tasks.rb", "lib/jeweler/templates", "lib/jeweler/templates/bacon", "lib/jeweler/templates/bacon/flunking.rb", "lib/jeweler/templates/bacon/helper.rb", "lib/jeweler/templates/features", "lib/jeweler/templates/features/default.feature", "lib/jeweler/templates/features/support", "lib/jeweler/templates/features/support/env.rb", "lib/jeweler/templates/LICENSE", "lib/jeweler/templates/micronaut", "lib/jeweler/templates/micronaut/flunking.rb", "lib/jeweler/templates/micronaut/helper.rb", "lib/jeweler/templates/minitest", "lib/jeweler/templates/minitest/flunking.rb", "lib/jeweler/templates/minitest/helper.rb", "lib/jeweler/templates/Rakefile", "lib/jeweler/templates/README.rdoc", "lib/jeweler/templates/rspec", "lib/jeweler/templates/rspec/flunking.rb", "lib/jeweler/templates/rspec/helper.rb", "lib/jeweler/templates/shoulda", "lib/jeweler/templates/shoulda/flunking.rb", "lib/jeweler/templates/shoulda/helper.rb", "lib/jeweler/templates/testunit", "lib/jeweler/templates/testunit/flunking.rb", "lib/jeweler/templates/testunit/helper.rb", "lib/jeweler/version_helper.rb", "lib/jeweler.rb", "test/fixtures", "test/fixtures/bar", "test/fixtures/bar/VERSION.yml", "test/geminstaller.yml", "test/generators", "test/generators/initialization_test.rb", "test/jeweler", "test/jeweler/commands", "test/jeweler/commands/test_build_gem.rb", "test/jeweler/commands/test_install_gem.rb", "test/jeweler/commands/test_release.rb", "test/jeweler/commands/test_release_to_rubyforge.rb", "test/jeweler/commands/test_write_gemspec.rb", "test/jeweler/commands/version", "test/jeweler/commands/version/test_bump_major.rb", "test/jeweler/commands/version/test_bump_minor.rb", "test/jeweler/commands/version/test_bump_patch.rb", "test/jeweler/commands/version/test_write.rb", "test/shoulda_macros", "test/shoulda_macros/jeweler_macros.rb", "test/test_application.rb", "test/test_gemspec_helper.rb", "test/test_generator.rb", "test/test_helper.rb", "test/test_jeweler.rb", "test/test_options.rb", "test/test_tasks.rb", "test/test_version_helper.rb", "test/version_tmp", "test/version_tmp/VERSION.yml", "lib/jeweler/templates/.gitignore"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/technicalpickles/jeweler}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
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
