Feature:
  Includes unobtainium-multiwait and unobtainium-multifind

  Scenario: Multifind
    Given I have a driver
    Then I expect it to respond to "multifind"

  Scenario: Multiwait
    Given I have a driver
    Then I expect it to respond to "multiwait"

