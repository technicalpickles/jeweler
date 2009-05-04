# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jeweler}
  s.version = "0.11.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Nichols"]
  s.date = %q{2009-05-04}
  s.default_executable = %q{jeweler}
  s.description = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}
  s.email = %q{josh@technicalpickles.com}
  s.executables = ["jeweler"]
  s.extra_rdoc_files = [
    "ChangeLog.markdown",
    "LICENSE",
    "README.markdown"
  ]
  s.files = [
    "ChangeLog.markdown",
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION.yml",
    "bin/jeweler",
    "lib/jeweler.rb",
    "lib/jeweler/commands.rb",
    "lib/jeweler/commands/build_gem.rb",
    "lib/jeweler/commands/install_gem.rb",
    "lib/jeweler/commands/release.rb",
    "lib/jeweler/commands/release_to_rubyforge.rb",
    "lib/jeweler/commands/setup_rubyforge.rb",
    "lib/jeweler/commands/validate_gemspec.rb",
    "lib/jeweler/commands/version/base.rb",
    "lib/jeweler/commands/version/bump_major.rb",
    "lib/jeweler/commands/version/bump_minor.rb",
    "lib/jeweler/commands/version/bump_patch.rb",
    "lib/jeweler/commands/version/write.rb",
    "lib/jeweler/commands/write_gemspec.rb",
    "lib/jeweler/errors.rb",
    "lib/jeweler/gemspec_helper.rb",
    "lib/jeweler/generator.rb",
    "lib/jeweler/generator/application.rb",
    "lib/jeweler/generator/bacon_mixin.rb",
    "lib/jeweler/generator/micronaut_mixin.rb",
    "lib/jeweler/generator/minitest_mixin.rb",
    "lib/jeweler/generator/options.rb",
    "lib/jeweler/generator/rspec_mixin.rb",
    "lib/jeweler/generator/shoulda_mixin.rb",
    "lib/jeweler/generator/testunit_mixin.rb",
    "lib/jeweler/specification.rb",
    "lib/jeweler/tasks.rb",
    "lib/jeweler/templates/.document",
    "lib/jeweler/templates/.gitignore",
    "lib/jeweler/templates/LICENSE",
    "lib/jeweler/templates/README.rdoc",
    "lib/jeweler/templates/Rakefile",
    "lib/jeweler/templates/bacon/flunking.rb",
    "lib/jeweler/templates/bacon/helper.rb",
    "lib/jeweler/templates/features/default.feature",
    "lib/jeweler/templates/features/support/env.rb",
    "lib/jeweler/templates/micronaut/flunking.rb",
    "lib/jeweler/templates/micronaut/helper.rb",
    "lib/jeweler/templates/minitest/flunking.rb",
    "lib/jeweler/templates/minitest/helper.rb",
    "lib/jeweler/templates/rspec/flunking.rb",
    "lib/jeweler/templates/rspec/helper.rb",
    "lib/jeweler/templates/shoulda/flunking.rb",
    "lib/jeweler/templates/shoulda/helper.rb",
    "lib/jeweler/templates/testunit/flunking.rb",
    "lib/jeweler/templates/testunit/helper.rb",
    "lib/jeweler/version_helper.rb",
    "test/fixtures/bar/VERSION.yml",
    "test/fixtures/bar/bin/foo_the_ultimate_bin",
    "test/fixtures/bar/hey_include_me_in_gemspec",
    "test/fixtures/bar/lib/foo_the_ultimate_lib.rb",
    "test/fixtures/existing-project-with-version/LICENSE",
    "test/fixtures/existing-project-with-version/README.rdoc",
    "test/fixtures/existing-project-with-version/Rakefile",
    "test/fixtures/existing-project-with-version/VERSION.yml",
    "test/fixtures/existing-project-with-version/existing-project-with-version.gemspec",
    "test/fixtures/existing-project-with-version/lib/existing_project_with_version.rb",
    "test/fixtures/existing-project-with-version/test/existing_project_with_version_test.rb",
    "test/fixtures/existing-project-with-version/test/test_helper.rb",
    "test/geminstaller.yml",
    "test/jeweler/commands/test_build_gem.rb",
    "test/jeweler/commands/test_install_gem.rb",
    "test/jeweler/commands/test_release.rb",
    "test/jeweler/commands/test_release_to_rubyforge.rb",
    "test/jeweler/commands/test_setup_rubyforge.rb",
    "test/jeweler/commands/test_validate_gemspec.rb",
    "test/jeweler/commands/test_write_gemspec.rb",
    "test/jeweler/commands/version/test_base.rb",
    "test/jeweler/commands/version/test_bump_major.rb",
    "test/jeweler/commands/version/test_bump_minor.rb",
    "test/jeweler/commands/version/test_bump_patch.rb",
    "test/jeweler/commands/version/test_write.rb",
    "test/shoulda_macros/jeweler_macros.rb",
    "test/test_application.rb",
    "test/test_gemspec_helper.rb",
    "test/test_generator.rb",
    "test/test_generator_initialization.rb",
    "test/test_generator_mixins.rb",
    "test/test_helper.rb",
    "test/test_jeweler.rb",
    "test/test_options.rb",
    "test/test_specification.rb",
    "test/test_tasks.rb",
    "test/test_version_helper.rb",
    "test/version_tmp/VERSION.yml"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/technicalpickles/jeweler}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pickles}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}
  s.test_files = [
    "test/fixtures/bar/lib/foo_the_ultimate_lib.rb",
    "test/fixtures/existing-project-with-version/lib/existing_project_with_version.rb",
    "test/fixtures/existing-project-with-version/test/existing_project_with_version_test.rb",
    "test/fixtures/existing-project-with-version/test/test_helper.rb",
    "test/jeweler/commands/test_build_gem.rb",
    "test/jeweler/commands/test_install_gem.rb",
    "test/jeweler/commands/test_release.rb",
    "test/jeweler/commands/test_release_to_rubyforge.rb",
    "test/jeweler/commands/test_setup_rubyforge.rb",
    "test/jeweler/commands/test_validate_gemspec.rb",
    "test/jeweler/commands/test_write_gemspec.rb",
    "test/jeweler/commands/version/test_base.rb",
    "test/jeweler/commands/version/test_bump_major.rb",
    "test/jeweler/commands/version/test_bump_minor.rb",
    "test/jeweler/commands/version/test_bump_patch.rb",
    "test/jeweler/commands/version/test_write.rb",
    "test/shoulda_macros/jeweler_macros.rb",
    "test/test_application.rb",
    "test/test_gemspec_helper.rb",
    "test/test_generator.rb",
    "test/test_generator_initialization.rb",
    "test/test_generator_mixins.rb",
    "test/test_helper.rb",
    "test/test_jeweler.rb",
    "test/test_options.rb",
    "test/test_specification.rb",
    "test/test_tasks.rb",
    "test/test_version_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<git>, [">= 1.1.1"])
      s.add_runtime_dependency(%q<rubyforge>, [">= 0"])
    else
      s.add_dependency(%q<git>, [">= 1.1.1"])
      s.add_dependency(%q<rubyforge>, [">= 0"])
    end
  else
    s.add_dependency(%q<git>, [">= 1.1.1"])
    s.add_dependency(%q<rubyforge>, [">= 0"])
  end
end
