Feature: rspec generator
  In order to start a new gem
  A user should be able to
  generate a project setup for rspec

  Scenario: directory layout
    Given a working directory
    And I have configured git sanely
    And I intend to test with rspec
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a directory named 'the-perfect-gem/spec' is created

    And a file named 'the-perfect-gem/spec/spec_helper.rb' is created
    And a file named 'the-perfect-gem/spec/the_perfect_gem_spec.rb' is created

  Scenario: Rakefile
    Given a working directory
    And I have configured git sanely
    And I intend to test with rspec
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'spec/**/*_spec.rb' in the Spec::Rake::SpecTask pattern

  Scenario: generated spec
    Given a working directory
    And I have configured git sanely
    And I intend to test with rspec
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'spec/the_perfect_gem_spec.rb' should describe 'ThePerfectGem'

  Scenario: generated spec helper
    Given a working directory
    And I have configured git sanely
    And I intend to test with rspec
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'spec/spec_helper.rb' requires 'spec'
    And 'spec/spec_helper.rb' requires 'the_perfect_gem'
