Feature: bacon generator
  In order to start a new gem
  A user should be able to
  generate a project setup for bacon

  Scenario: generating a gem with bacon tests
    Given a working directory
    And I have configured git sanely
    And I intend to test with bacon

    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a directory named 'the-perfect-gem/spec' is created
    
    And a file named 'the-perfect-gem/spec/spec_helper.rb' is created
    And a file named 'the-perfect-gem/spec/the_perfect_gem_spec.rb' is created

    And Rakefile has 'spec/**/*_spec.rb' in the Rake::TestTask pattern
    And Rakefile has 'spec/**/*_spec.rb' in the Rcov::RcovTask test_pattern
    And Rakefile has 'spec' in the Rcov::RcovTask libs

    And 'spec/the_perfect_gem_spec.rb' should describe 'ThePerfectGem'

    And 'spec/spec_helper.rb' requires 'bacon'
    And 'spec/spec_helper.rb' requires 'the_perfect_gem'
    
    And 'spec/spec_helper.rb' was checked in
    And 'spec/the_perfect_gem_spec.rb' was checked in
