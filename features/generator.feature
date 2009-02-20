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

    And a sane '.gitignore' is created

    And Rakefile has 'the-perfect-gem' as the gem name
    And Rakefile has 'bar@example.com' as the gem email
    And Rakefile has 'zomg, so good' as the gem summary
    And Rakefile has 'http://github.com/technicalpickles/the-perfect-gem' as the gem homepage

    And LICENSE has the copyright as belonging to 'foo' in '2008'

    And git repository has 'origin' remote
    And git repository 'origin' remote should be 'git@github.com:technicalpickles/the-perfect-gem.git'

    And a commit with the message 'Initial commit to the-perfect-gem.' is made
    And 'README' was checked in
    And 'Rakefile' was checked in
    And 'LICENSE' was checked in
    And 'lib/the_perfect_gem.rb' was checked in
    And '.gitignore' was checked in
    And no files are untracked
    And no files are changed
    And no files are added
    And no files are deleted
