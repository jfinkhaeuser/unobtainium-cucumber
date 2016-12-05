Feature:
  Action support functions

  Scenario Outline: Filename from scenario
    Given I have a scenario named <name>
    And I provide a tag <tag>
    And the timestamp is <timestamp>
    Then I expect the filename to match <filename>

    Examples:
      # Note:
      #   - all caps NIL becomes Ruby nil.
      #   - the filename will be interpreted as a regular expression as much
      #     as possible.
      | name          | tag     | timestamp            | filename                               |
      | some scenario | NIL     | 2016-11-25T15:48:13Z | 2016_11_25T15_48_13Z-some_scenario     |
      | some \| pipe  | the_tag | 2016-11-25T15:48:13Z | 2016_11_25T15_48_13Z-the_tag-some_pipe |
