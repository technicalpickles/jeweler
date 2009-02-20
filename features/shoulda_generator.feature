Feature: shoulda generator
  In order to start a new gem
  A user should be able to
  generate a project setup for shoulda

  Scenario: generating a gem with shoulda tests
    Given a working directory
    And I have configured git sanely
    And I decide to call the project 'the-perfect-gem'
    And I decide to summarize the project as 'zomg, so good'
    And I intend to test with shoulda

    When I generate a project

    Then a directory named 'the-perfect-gem' is created
    And a directory named 'the-perfect-gem/lib' is created
    And a directory named 'the-perfect-gem/test' is created
    And cucumber directories are created

    And a file named 'the-perfect-gem/README' is created
    And a file named 'the-perfect-gem/lib/the_perfect_gem.rb' is created
    And a file named 'the-perfect-gem/test/test_helper.rb' is created
    And a file named 'the-perfect-gem/test/the_perfect_gem_test.rb' is created
    And a file named 'the-perfect-gem/.gitignore' is created

    And a file named 'the-perfect-gem/features/the_perfect_gem.feature' is created
    And a file named 'the-perfect-gem/features/support/env.rb' is created
    And a file named 'the-perfect-gem/features/steps/the_perfect_gem_steps.rb' is created

    And 'coverage' is ignored by git
    And '*.sw?' is ignored by git
    And '.DS_Store' is ignored by git
    And 'rdoc' is ignored by git
    And 'pkg' is ignored by git

    And Rakefile has 'the-perfect-gem' as the gem name
    And Rakefile has 'bar@example.com' as the gem email
    And Rakefile has 'zomg, so good' as the gem summary
    And Rakefile has 'http://github.com/technicalpickles/the-perfect-gem' as the gem homepage
    And Rakefile has 'test/**/*_test.rb' in the Rake::TestTask pattern
    And Rakefile has 'test/**/*_test.rb' in the Rcov::RcovTask test_pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs

    And LICENSE has the copyright as belonging to 'foo' in '2008'

    And 'test/the_perfect_gem_test.rb' should define 'ThePerfectGemTest' as a subclass of 'Test::Unit::TestCase'

    And 'test/test_helper.rb' requires 'test/unit'
    And 'test/test_helper.rb' requires 'shoulda'
    And 'test/test_helper.rb' requires 'mocha'
    And 'test/test_helper.rb' requires 'the_perfect_gem'

    And 'features/support/env.rb' requires 'the_perfect_gem'
    And 'features/support/env.rb' requires 'test/unit/assertions'
    And 'features/support/env.rb' sets up features to use test/unit assertions

    And git repository has 'origin' remote
    And git repository 'origin' remote should be 'git@github.com:technicalpickles/the-perfect-gem.git'

    And a commit with the message 'Initial commit to the-perfect-gem.' is made
    And 'README' was checked in
    And 'Rakefile' was checked in
    And 'LICENSE' was checked in
    And 'lib/the_perfect_gem.rb' was checked in
    And 'test/test_helper.rb' was checked in
    And 'test/the_perfect_gem_test.rb' was checked in
    And '.gitignore' was checked in
    And no files are untracked
    And no files are changed
    And no files are added
    And no files are deleted
    
