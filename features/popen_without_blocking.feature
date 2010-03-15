Feature: Run simple subprocesses without blocking in ruby

  As a ruby hacker
  I want to run system subprocesses that do not block
  And I want to have them presented as objects
  So that I can get more data about said subprocesses
  And so that I can have more fine grained control of said subprocesses

  Scenario: run simple subprocess without blocking
    Given I have a new subprocess that takes a long time to run
    When I invoke the run method of said nonblocking subprocess
    Then the subprocess should not block
    And the subprocess should report its run status
    And the subprocess should support being waited on till complete
    And the subprocess should have status info

