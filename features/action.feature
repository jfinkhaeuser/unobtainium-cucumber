Feature:
  Action functions

  Scenario: Screenshot taking
    Given I take a screenshot
    Then I expect there to be a matching screenshot file


  Scenario: Content capture
    Given I navigate to the best site in the world
    When I capture the page content
    Then I expect there to be a matching content file
