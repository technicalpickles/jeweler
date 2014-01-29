Feature: generated Gemfiel
  In order to start a new gem
  A user should be able to
  generate a Gemfile

  Background:
    Given a working directory
    And I have configured git sanely

  Scenario: disabled
    Given I do not want bundler
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then a file named 'the-perfect-gemGemfile' is not created

  Scenario: enabled
    Given I want bundler
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then a file named 'the-perfect-gem/Gemfile' is created

  Scenario: default
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then a file named 'the-perfect-gem/Gemfile' is created
    And 'Gemfile' uses the gemcutter source
    And 'Gemfile' has a development dependency on 'bundler'
    And 'Gemfile' has a development dependency on the current version of jeweler
    And 'Gemfile' has a development dependency on 'simplecov'
    And 'Gemfile' has a development dependency on 'rcov'
    And 'Gemfile' has a development dependency on 'rdoc'
    And 'Gemfile' does not have a development dependency on 'yard'

  Scenario: bacon
    When I generate a bacon project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'bacon'

  Scenario: minitest
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'minitest'

  Scenario: rspec
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Gemfile' has a development dependency on 'rspec'

  Scenario: shoulda
    When I generate a shoulda project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'shoulda'

  Scenario: micronaut
    When I generate a micronaut project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'micronaut'

  Scenario: cucumber
    Given I want cucumber stories
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'cucumber'

  Scenario: reek
    Given I want reek
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'reek'

  Scenario: roodi
    Given I want roodi
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'roodi'

  Scenario: rdoc
    Given I want to use rdoc instead of yard
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'rdoc'
    And 'Gemfile' does not have a development dependency on 'yard'

  Scenario: yard
    Given I want to use yard instead of rdoc
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'yard'
    Then 'Gemfile' has a development dependency on 'rdoc'

  Scenario: shindo
    When I generate a shindo project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' has a development dependency on 'shindo'
