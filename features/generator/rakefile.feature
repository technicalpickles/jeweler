Feature: generated Rakefile
  In order to start a new gem
  A user should be able to
  generate a Rakefile

  Scenario: shared
    Given a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'the-perfect-gem' for the Jeweler::Tasks name
    And Rakefile has 'bar@example.com' for the Jeweler::Tasks email
    And Rakefile has 'zomg, so good' for the Jeweler::Tasks summary
    And Rakefile has 'http://github.com/technicalpickles/the-perfect-gem' for the Jeweler::Tasks homepage

  Scenario: bacon
    Given a working directory
    And I have configured git sanely
    When I generate a bacon project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'spec/**/*_spec.rb' for the Rake::TestTask pattern
    And Rakefile has 'spec/**/*_spec.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'spec' in the Rcov::RcovTask libs

  Scenario: minitest
    Given a working directory
    And I have configured git sanely
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'test/**/*_test.rb' for the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs

  Scenario: rspec
    Given a working directory
    And I have configured git sanely
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'spec/**/*_spec.rb' for the Spec::Rake::SpecTask pattern

  Scenario: shoulda
    Given a working directory
    And I have configured git sanely
    When I generate a shoulda project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'test/**/*_test.rb' for the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs

  Scenario: testunit
    Given a working directory
    And I have configured git sanely
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'

    Then Rakefile has 'test/**/*_test.rb' for the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs
