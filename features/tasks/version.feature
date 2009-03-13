Feature: version rake task

  Scenario: a newly created project without a version
    Given a working directory
    And I use the jeweler command to generate the "the-perfect-gem" project in the working directory
    And "the-perfect-gem/VERSION.yml" does not exist
    When I run "rake version" in "the-perfect-gem"
    Then the process should exit cleanly
    And the current version, 0.0.0, is displayed

  Scenario: an existing project with version
    Given a working directory
    And I use the existing project "existing-project-with-version" as a template
    And "VERSION.yml" contains hash "{ :major => 1, :minor => 5, :patch => 3}"
    When I run "rake version" in "existing-project-with-version"
    Then the process should exit cleanly
    And the current version, 1.5.3, is displayed
