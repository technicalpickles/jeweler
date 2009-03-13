Feature: git support
  In order to start a new gem for GitHub
  A user should be able to
  generate a project that is setup for git

  Scenario: git remote configuration
    Given I am in a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then git repository has 'origin' remote
    And git repository 'origin' remote should be 'git@github.com:technicalpickles/the-perfect-gem.git'

  Scenario: .gitignore
    Given I am in a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a sane '.gitignore' is created

  Scenario: baseline repository
    Given I am in a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a commit with the message 'Initial commit to the-perfect-gem.' is made
    And 'README.rdoc' was checked in
    And 'Rakefile' was checked in
    And 'LICENSE' was checked in
    And 'lib/the_perfect_gem.rb' was checked in
    And '.gitignore' was checked in

    And no files are untracked
    And no files are changed
    And no files are added
    And no files are deleted

  Scenario: bacon
    Given I am in a working directory
    And I have configured git sanely
    When I generate a bacon project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'spec/spec_helper.rb' was checked in
    And 'spec/the_perfect_gem_spec.rb' was checked in

  Scenario: minitest
    Given I am in a working directory
    And I have configured git sanely
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'test/test_helper.rb' was checked in
    And 'test/the_perfect_gem_test.rb' was checked in

  Scenario: rspec
    Given I am in a working directory
    And I have configured git sanely
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'spec/spec_helper.rb' was checked in
    And 'spec/the_perfect_gem_spec.rb' was checked in

  Scenario: shoulda
    Given I am in a working directory
    And I have configured git sanely
    When I generate a shoulda project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'test/test_helper.rb' was checked in
    And 'test/the_perfect_gem_test.rb' was checked in

  Scenario: testunit
    Given I am in a working directory
    And I have configured git sanely
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'test/test_helper.rb' was checked in
    And 'test/the_perfect_gem_test.rb' was checked in

  Scenario: micronaut
    Given I am in a working directory
    And I have configured git sanely
    When I generate a micronaut project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'examples/example_helper.rb' was checked in
    And 'examples/the_perfect_gem_example.rb' was checked in

  Scenario: cucumber
    Given I am in a working directory
    And I have configured git sanely
    And I want cucumber stories
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'features/the_perfect_gem.feature' was checked in
    And 'features/support/env.rb' was checked in
    And 'features/step_definitions/the_perfect_gem_steps.rb' was checked in
