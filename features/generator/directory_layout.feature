Feature: generated directory layout
  In order to start a new gem
  A user should be able to
  generate a directory layout

  Scenario: shared
    Given a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a directory named 'the-perfect-gem' is created
    And a directory named 'the-perfect-gem/lib' is created

    And a file named 'the-perfect-gem/README' is created
    And a file named 'the-perfect-gem/lib/the_perfect_gem.rb' is created


  Scenario: bacon
    Given a working directory
    And I have configured git sanely
    And I intend to test with bacon
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a directory named 'the-perfect-gem/spec' is created
    And a file named 'the-perfect-gem/spec/spec_helper.rb' is created
    And a file named 'the-perfect-gem/spec/the_perfect_gem_spec.rb' is created

  Scenario: minitest
    Given a working directory
    And I have configured git sanely
    And I intend to test with minitest
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a directory named 'the-perfect-gem/test' is created

    And a file named 'the-perfect-gem/test/test_helper.rb' is created
    And a file named 'the-perfect-gem/test/the_perfect_gem_test.rb' is created

  Scenario: rspec
    Given a working directory
    And I have configured git sanely
    And I intend to test with rspec
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a directory named 'the-perfect-gem/spec' is created

    And a file named 'the-perfect-gem/spec/spec_helper.rb' is created
    And a file named 'the-perfect-gem/spec/the_perfect_gem_spec.rb' is created

  Scenario: shoulda
    Given a working directory
    And I have configured git sanely
    And I intend to test with shoulda
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a directory named 'the-perfect-gem/test' is created
    And a file named 'the-perfect-gem/test/test_helper.rb' is created
    And a file named 'the-perfect-gem/test/the_perfect_gem_test.rb' is created

  Scenario: testunit
    Given a working directory
    And I have configured git sanely
    And I intend to test with testunit
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a directory named 'the-perfect-gem/test' is created

    And a file named 'the-perfect-gem/test/test_helper.rb' is created
    And a file named 'the-perfect-gem/test/the_perfect_gem_test.rb' is created
