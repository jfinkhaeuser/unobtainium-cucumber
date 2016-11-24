Feature:
  Provide the ability to conveniently perform actions when a scenario finishes
  and its status is known.

  Background:
    Given I have a test instance of the StatusActions module

  Scenario Outline: Function `#action_key`
    Given I have a scenario which has <has_passed>
    And the scenario <is_outline> an outline
    Then I expect the output to contain <status> and <type>

    Examples:
      | has_passed | is_outline | status   | type      |
      | passed     | is not     | :passed? | :scenario |
      | failed     | is not     | :failed? | :scenario |
      | passed     | is         | :passed? | :outline  |
      | failed     | is         | :failed? | :outline  |
