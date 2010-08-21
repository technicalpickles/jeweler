Feature: generated test or spec
  In order to start a new gem
  A user should be able to
  generate a test or spec

  Scenario: bacon
    Given a working directory
    And I have configured git sanely
    When I generate a bacon project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'spec/spec_helper.rb' requires 'bacon'
    And 'spec/spec_helper.rb' requires 'the-perfect-gem'

  Scenario: minitest
    Given a working directory
    And I have configured git sanely
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/helper.rb' requires 'minitest/unit'
    And 'test/helper.rb' requires 'the-perfect-gem'
    And 'test/helper.rb' should autorun tests

  Scenario: rspec
    Given a working directory
    And I have configured git sanely
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'spec/spec_helper.rb' requires 'rspec'
    And 'spec/spec_helper.rb' requires 'rspec/autorun'
    And 'spec/spec_helper.rb' requires 'the-perfect-gem'

  Scenario: shoulda
    Given a working directory
    And I have configured git sanely
    When I generate a shoulda project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/helper.rb' requires 'test/unit'
    And 'test/helper.rb' requires 'shoulda'
    And 'test/helper.rb' requires 'the-perfect-gem'

  Scenario: testunit
    Given a working directory
    And I have configured git sanely
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/helper.rb' requires 'test/unit'
    And 'test/helper.rb' requires 'the-perfect-gem'

  Scenario: micronaut w/ bundler
    Given a working directory
    And I have configured git sanely
    And I want bundler
    When I generate a micronaut project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'examples/example_helper.rb' requires 'rubygems'
    Then 'examples/example_helper.rb' requires 'micronaut'
    Then 'examples/example_helper.rb' requires 'the-perfect-gem'
    And 'examples/example_helper.rb' requires 'bundler'
    And 'examples/example_helper.rb' sets up bundler using the default and development groups

  Scenario: micronaut w/o bundler
    Given a working directory
    And I have configured git sanely
    And I do not want bundler
    When I generate a micronaut project named 'the-perfect-gem' that is 'zomg, so good'
    And 'examples/example_helper.rb' does not require 'bundler'
    And 'examples/example_helper.rb' does not setup bundler

  Scenario: riot w/ bundler
    Given a working directory
      And I have configured git sanely
      And I want bundler
    When I generate a riot project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'test/teststrap.rb' requires 'riot'
      And 'test/teststrap.rb' requires 'the-perfect-gem'
      And 'test/teststrap.rb' requires 'bundler'
      And 'test/teststrap.rb' sets up bundler using the default and development groups

  Scenario: riot w/o bundler
    Given a working directory
      And I have configured git sanely
      And I do not want bundler
    When I generate a riot project named 'the-perfect-gem' that is 'zomg, so good'
      And 'test/teststrap.rb' does not require 'bundler'
      And 'test/teststrap.rb' does not setup bundler

  Scenario: shindo w/ bundler
    Given a working directory
    And I have configured git sanely
    And I want bundler
    When I generate a shindo project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'tests/tests_helper.rb' requires 'the-perfect-gem'
    Then 'tests/tests_helper.rb' requires 'shindo'
    Then 'tests/tests_helper.rb' requires 'bundler'
    And 'tests/tests_helper.rb' sets up bundler using the default and development groups

  Scenario: shindo w/o bundler
    Given a working directory
    And I have configured git sanely
    And I do not want bundler
    When I generate a shindo project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'tests/tests_helper.rb' does not require 'bundler'
    And 'tests/tests_helper.rb' does not setup bundler
