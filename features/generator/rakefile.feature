Feature: generated Rakefile
  In order to start a new gem
  A user should be able to
  generate a Rakefile

  Scenario: shared
    Given a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'rubygems'
    And 'Rakefile' requires 'rake'
    And 'Rakefile' requires 'rake/rdoctask'
    And Rakefile has 'the-perfect-gem' for the Jeweler::Tasks name
    And Rakefile has 'bar@example.com' for the Jeweler::Tasks email
    And Rakefile has 'zomg, so good' for the Jeweler::Tasks summary
    And Rakefile has 'http://github.com/technicalpickles/the-perfect-gem' for the Jeweler::Tasks homepage

  Scenario: bacon
    Given a working directory
    And I have configured git sanely
    When I generate a bacon project named 'the-perfect-gem' that is 'zomg, so good'

    
    Then 'Rakefile' requires 'rcov/rcovtask'
    And Rakefile has 'spec/**/*_spec.rb' for the Rake::TestTask pattern
    And Rakefile has 'spec/**/*_spec.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'spec' in the Rcov::RcovTask libs
    And Rakefile has "spec" as the default task

  Scenario: minitest
    Given a working directory
    And I have configured git sanely
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'rcov/rcovtask'
    And Rakefile has 'test/**/*_test.rb' for the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs
    And Rakefile has "test" as the default task

  Scenario: rspec
    Given a working directory
    And I have configured git sanely
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'spec/rake/spectask'
    And Rakefile has 'spec/**/*_spec.rb' for the Spec::Rake::SpecTask pattern
    And Rakefile has "spec" as the default task

  Scenario: shoulda
    Given a working directory
    And I have configured git sanely
    When I generate a shoulda project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'rcov/rcovtask'
    And Rakefile has 'test/**/*_test.rb' for the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs
    And Rakefile has "test" as the default task

  Scenario: micronaut
    Given a working directory
    And I have configured git sanely
    When I generate a micronaut project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'micronaut/rake_task'
    And Rakefile has 'examples/**/*_example.rb' for the Micronaut::RakeTask pattern
    And Rakefile has "examples" as the default task

  Scenario: testunit
    Given a working directory
    And I have configured git sanely
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'rcov/rcovtask'
    Then Rakefile has 'test/**/*_test.rb' for the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs
    And Rakefile has "test" as the default task

  Scenario: no cucumber
    Given a working directory
    And I have configured git sanely
    And I do not want cucumber stories
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile does not require 'cucumber/rake/task' 
    And Rakefile does not instantiate a Cucumber::Rake::Task

  Scenario: cucumber
    Given a working directory
    And I have configured git sanely
    And I want cucumber stories
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile requires 'cucumber/rake/task' 
    And Rakefile instantiates a Cucumber::Rake::Task

  Scenario: no rubyforge
    Given a working directory
    And I have configured git sanely
    And I do not want rubyforge setup
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile does not require 'rake/contrib/sshpublisher'

  Scenario: rubyforge
    Given a working directory
    And I have configured git sanely
    And I want rubyforge setup
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile requires 'rake/contrib/sshpublisher' 
    And Rakefile has 'the-perfect-gem' for the Jeweler::Tasks rubyforge_project
