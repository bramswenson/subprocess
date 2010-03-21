Feature: Run simple subprocesses that report running

  As a ruby hacker
  I want to run system subprocesses that report their running status
  So that I know when said subprocess is finished without waiting

  Scenario: run simple subprocess that finishes fast
    Given I have a new subprocess that runs fast
    When I invoke the run method of said fast subprocess
    Then the subprocess should report running as false without waiting

