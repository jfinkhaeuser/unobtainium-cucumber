Feature:
  Translation to Octiron Events

  Scenario: An Event
    Given I register a handler for AfterTestStep
    Then I expect that handler to be fired
