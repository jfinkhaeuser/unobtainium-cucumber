Feature:
  Provide the ability to conveniently perform actions when a scenario finishes
  and its status is known.

  Background:
    Given I have a test instance of the StatusActions module
    Then I expect all configured actions to be present
    And I want to clear configured actions

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

  Scenario Outline: Function `#register_action` status
    Given I try to register an action for status <status>
    Then I expect the function to <succeed_or_fail>

    Examples:
      | status  | succeed_or_fail |
      | passed? | succeed         |
      | failed? | succeed         |
      | passed  | fail            |
      |         | fail            |

  Scenario Outline: Function `#register_action` type option
    Given I try to register an action for the type <type>
    Then I expect the function to <succeed_or_fail>

    Examples:
      | type     | succeed_or_fail |
      | scenario | succeed         |
      | outline  | succeed         |
      | other    | fail            |
      |          | fail            |

  Scenario: Try to register neither function nor block
    Given I try to register no action
    Then I expect the function to fail

  Scenario: Try to register both function and block
    Given I try to register two actions
    Then I expect the function to fail

  Scenario: No action, but options
    Given I register no action, but provide options
    Then I expect the there to be an error

  Scenario: Invalid Hash action
    Given I register a Hash as an action
    Then I expect the there to be an error

  Scenario: Multiple actions
    Given I register an action
    When I register another action
    Then I expect there to be two registered actions

  Scenario: No actions
    Given I have registered no actions
    Then I expect there to be no registered actions

  Scenario: Action is executed
    Given I have registered an action
    Then I expect it to be executed

  Scenario: Configured actions should be present
    Given I register configured actions
    Then I expect only configured actions to be present

  Scenario: Execute method
    Given I execute a method action
    Then I expect this to succeed

  Scenario: Execute block
    Given I execute a block action
    Then I expect this to succeed

  Scenario: Execute symbol
    Given I execute a symbol action
    Then I expect this to succeed

  Scenario: Execute string
    Given I execute a string action
    Then I expect this to succeed

  Scenario: Execute namespaced string
    Given I execute a namespaced string action
    Then I expect this to succeed

  Scenario: Execute dot-separated namespaced string
    Given I execute a namespaced string action that is dot-separated
    Then I expect this to succeed

  Scenario: Execute non-resolving string
    Given I execute string action that does not resolve
    Then I expect this to fail

  Scenario: Execute non-resolving symbol
    Given I execute symbol action that does not resolve
    Then I expect this to fail

  Scenario: Execute non-resolving string with two dots
    Given I execute string action with two dots
    Then I expect this to fail

  Scenario: Try to execute number
    Given I execute a number action
    Then I expect this to fail
