Feature: generated license
  In order to start a new gem
  A user should be able to
  generate a default license

  Background:
    Given a working directory

  Scenario: crediting user
    Given I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then LICENSE.txt credits 'foo'

  Scenario: copyright in the current year
    Given it is the year 2005
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'

    Then LICENSE.txt has a copyright in the year 2005
