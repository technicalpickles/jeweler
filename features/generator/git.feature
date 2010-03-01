Feature: git support
  In order to start a new gem for GitHub
  A user should be able to
  generate a project that is setup for git

  Scenario: git remote configuration
    Given a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then git repository has 'origin' remote
    And git repository 'origin' remote should be 'git@github.com:technicalpickles/the-perfect-gem.git'

  Scenario: .gitignore
    Given a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then a sane '.gitignore' is created

