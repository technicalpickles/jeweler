Feature: generated test or spec
  In order to start a new gem
  A user should be able to
  generate a test or spec

  Scenario: bacon
    Given a working directory
    And I have configured git sanely
    And I intend to test with bacon
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'spec/spec_helper.rb' requires 'bacon'
    And 'spec/spec_helper.rb' requires 'the_perfect_gem'

  Scenario: minitest
    Given a working directory
    And I have configured git sanely
    And I intend to test with minitest
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/test_helper.rb' requires 'mini/test'
    And 'test/test_helper.rb' requires 'the_perfect_gem'
    And 'test/test_helper.rb' should autorun tests

  Scenario: rspec
    Given a working directory
    And I have configured git sanely
    And I intend to test with rspec
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'spec/spec_helper.rb' requires 'spec'
    And 'spec/spec_helper.rb' requires 'the_perfect_gem'

  Scenario: shoulda
    Given a working directory
    And I have configured git sanely
    And I intend to test with shoulda
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/test_helper.rb' requires 'test/unit'
    And 'test/test_helper.rb' requires 'shoulda'
    And 'test/test_helper.rb' requires 'mocha'
    And 'test/test_helper.rb' requires 'the_perfect_gem'

  Scenario: testunit
    Given a working directory
    And I have configured git sanely
    And I intend to test with testunit
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/test_helper.rb' requires 'test/unit'
    And 'test/test_helper.rb' requires 'mocha'
    And 'test/test_helper.rb' requires 'the_perfect_gem'
