Feature: generated Rakefile
  In order to start a new gem
  A user should be able to
  generate a Rakefile

  Scenario: shared
    Given a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'the-perfect-gem' as the gem name
    And Rakefile has 'bar@example.com' as the gem email
    And Rakefile has 'zomg, so good' as the gem summary
    And Rakefile has 'http://github.com/technicalpickles/the-perfect-gem' as the gem homepage

  Scenario: bacon
    Given a working directory
    And I have configured git sanely
    And I intend to test with bacon
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'spec/**/*_spec.rb' in the Rake::TestTask pattern
    And Rakefile has 'spec/**/*_spec.rb' in the Rcov::RcovTask test_pattern
    And Rakefile has 'spec' in the Rcov::RcovTask libs

  Scenario: minitest
    Given a working directory
    And I have configured git sanely
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'test/**/*_test.rb' in the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' in the Rcov::RcovTask test_pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs

  Scenario: rspec
    Given a working directory
    And I have configured git sanely
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'spec/**/*_spec.rb' in the Spec::Rake::SpecTask pattern

  Scenario: shoulda
    Given a working directory
    And I have configured git sanely
    When I generate a shoulda project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'test/**/*_test.rb' in the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' in the Rcov::RcovTask test_pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs

  Scenario: testunit
    Given a working directory
    And I have configured git sanely
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'test/**/*_test.rb' in the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' in the Rcov::RcovTask test_pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs
