Feature: shoulda generator
  In order to start a new gem
  A user should be able to
  generate a project setup for testunit

  Scenario: generating a gem with testunit tests
    Given a working directory
    And I have configured git sanely

    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a directory named 'the-perfect-gem' is created
    And a directory named 'the-perfect-gem/lib' is created

    And a file named 'the-perfect-gem/README' is created
    And a file named 'the-perfect-gem/lib/the_perfect_gem.rb' is created

    And Rakefile has 'the-perfect-gem' as the gem name
    And Rakefile has 'bar@example.com' as the gem email
    And Rakefile has 'zomg, so good' as the gem summary
    And Rakefile has 'http://github.com/technicalpickles/the-perfect-gem' as the gem homepage

    And LICENSE has the copyright as belonging to 'foo' in '2008'
