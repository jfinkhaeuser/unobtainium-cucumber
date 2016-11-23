Feature:
  User-defined extensions should work with this gem

  Scenario: World contains user-defined extensions
    Given I register an extension with cucumber's World
    Then I expect this extension to be used

