Feature: generated test or spec
  In order to start a new gem
  A user should be able to
  generate a test or spec

  Scenario: bacon
    Given I am in a working directory
    And I have configured git sanely
    When I generate a bacon project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'spec/spec_helper.rb' requires 'bacon'
    And 'spec/spec_helper.rb' requires 'the_perfect_gem'

  Scenario: minitest
    Given I am in a working directory
    And I have configured git sanely
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/test_helper.rb' requires 'mini/test'
    And 'test/test_helper.rb' requires 'the_perfect_gem'
    And 'test/test_helper.rb' should autorun tests

  Scenario: rspec
    Given I am in a working directory
    And I have configured git sanely
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'spec/spec_helper.rb' requires 'spec'
    And 'spec/spec_helper.rb' requires 'the_perfect_gem'

  Scenario: shoulda
    Given I am in a working directory
    And I have configured git sanely
    When I generate a shoulda project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/test_helper.rb' requires 'test/unit'
    And 'test/test_helper.rb' requires 'shoulda'
    And 'test/test_helper.rb' requires 'the_perfect_gem'

  Scenario: testunit
    Given I am in a working directory
    And I have configured git sanely
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/test_helper.rb' requires 'test/unit'
    And 'test/test_helper.rb' requires 'the_perfect_gem'
  
  Scenario: micronaut
    Given I am in a working directory
    And I have configured git sanely
    When I generate a micronaut project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'examples/example_helper.rb' requires 'rubygems'
    Then 'examples/example_helper.rb' requires 'micronaut'
    Then 'examples/example_helper.rb' requires 'the_perfect_gem'
