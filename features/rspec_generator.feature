Feature: rspec generator
  In order to start a new gem
  A user should be able to
  generate a project setup for rspec

  Scenario: generating a gem with rspec tests
    Given a working directory
    And I have configured git sanely
    And I decide to call the project 'the-perfect-gem' that is 'zomg, so good'
    And I intend to test with rspec

    When I generate a project

    And a directory named 'the-perfect-gem/spec' is created
    And cucumber directories are created

    And a file named 'the-perfect-gem/spec/spec_helper.rb' is created
    And a file named 'the-perfect-gem/spec/the_perfect_gem_spec.rb' is created

    And a file named 'the-perfect-gem/features/the_perfect_gem.feature' is created
    And a file named 'the-perfect-gem/features/support/env.rb' is created
    And a file named 'the-perfect-gem/features/steps/the_perfect_gem_steps.rb' is created

    And Rakefile has 'spec/**/*_spec.rb' in the Spec::Rake::SpecTask pattern

    And 'spec/the_perfect_gem_spec.rb' should describe 'ThePerfectGem'

    And 'spec/spec_helper.rb' requires 'spec'
    And 'spec/spec_helper.rb' requires 'the_perfect_gem'
    
    And 'features/support/env.rb' requires 'the_perfect_gem'
    And 'features/support/env.rb' requires 'spec/expectations'
