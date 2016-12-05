Feature:
  Action functions

  Scenario: Screenshot taking
    Given I take a screenshot
    Then I expect there to be a matching screenshot file
