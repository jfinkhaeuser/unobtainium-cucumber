Feature:
  Drivers should be automatically reset after each scenario

  Background:
    Given I remove any reset functions

  Scenario: Reset driver by default
    Given I run a scenario to test driver reset
    Then the driver should be reset at the end

  Scenario: Skip if driver does not define reset
    Given I run a scenario with a driver that knowns no reset
    Then the driver should not be reset at the end

  Scenario: Skip if driver reset is switched off
    Given I run a scenario with driver reset switched off
    Then the driver should not be reset at the end
