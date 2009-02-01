Feature: shoulda generator
  In order to start a new gem
  A user should be able to
  generate a project setup for shoulda

  Scenario: generating a gem with shoulda tests
    Given a working directory
    And working git configuration
    And intentions to make a gem being tested by shoulda
    And I decide to call the project 'the-perfect-gem'

    When I generate a project

    Then a directory named 'the-perfect-gem' is created
    And a directory named 'the-perfect-gem/lib' is created
    And a directory named 'the-perfect-gem/test' is created

    And a file named 'the-perfect-gem/LICENSE' is created
    And a file named 'the-perfect-gem/README' is created
    And a file named 'the-perfect-gem/lib/the_perfect_gem.rb' is created
    And a file named 'the-perfect-gem/test/test_helper.rb' is created
    And a file named 'the-perfect-gem/test/the_perfect_gem_test.rb' is created
    And a file named 'the-perfect-gem/.gitignore' is created

    And 'coverage' is ignored by git
    And '*.sw?' is ignored by git
