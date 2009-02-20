Feature: minitest generator
  In order to start a new gem
  A user should be able to
  generate a project setup for minitest

  Scenario: generating a gem with minitest tests
    Given a working directory
    And I have configured git sanely
    And I intend to test with minitest

    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    And a directory named 'the-perfect-gem/test' is created
    And cucumber directories are created

    And a file named 'the-perfect-gem/test/test_helper.rb' is created
    And a file named 'the-perfect-gem/test/the_perfect_gem_test.rb' is created

    And a file named 'the-perfect-gem/features/the_perfect_gem.feature' is created
    And a file named 'the-perfect-gem/features/support/env.rb' is created
    And a file named 'the-perfect-gem/features/steps/the_perfect_gem_steps.rb' is created

    And Rakefile has 'test/**/*_test.rb' in the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' in the Rcov::RcovTask test_pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs

    And 'test/the_perfect_gem_test.rb' should define 'ThePerfectGemTest' as a subclass of 'Mini::Test::TestCase'

    And 'test/test_helper.rb' requires 'mini/test'
    And 'test/test_helper.rb' requires 'the_perfect_gem'
    And 'test/test_helper.rb' should autorun tests

    And 'features/support/env.rb' requires 'the_perfect_gem'
    And 'features/support/env.rb' requires 'mini/test'
    And 'features/support/env.rb' sets up features to use minitest assertions

    And 'test/test_helper.rb' was checked in
    And 'test/the_perfect_gem_test.rb' was checked in
