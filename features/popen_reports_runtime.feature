Feature: Run simple subprocesses that report run time

  As a ruby hacker
  I want to run system subprocesses that report their run time
  So that I know how long it took to run

  Scenario: run simple subprocess that takes 3 seconds
    Given I have a new subprocess that takes 3 seconds
    When I wait on said 3 second process to complete
    Then the subprocess should report a run time of around 3 seconds

