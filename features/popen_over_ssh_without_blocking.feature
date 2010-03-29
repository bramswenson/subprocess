Feature: Run simple remote subprocesses without blocking and over ssh in ruby

  As a ruby hacker
  I want to run remote system subprocesses that do not block over ssh
  And I want to have them presented as objects
  So that I can get more data about said subprocesses
  And so that I can have more fine grained control of said subprocesses

  Scenario: run simple remote nonblocking subprocess
    Given I have a new remote nonblocking subprocess that takes a long time to run
    When I invoke the run method of said nonblocking remote subprocess
    Then the remote nonblocking subprocess should not block
    And the remote nonblocking subprocess should report its run status
    And the remote nonblocking subprocess should support being waited on till complete
    And the remote nonblocking subprocess should have status info

