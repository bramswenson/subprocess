Feature: Run simple subprocesses stopping them at timeout if not complete

  As a ruby hacker
  I want to run system subprocesses 
  And I want them to terminate by a set timeout
  So that I don't end up with a bunch of zombies

  Scenario: run simple subprocess that goes past timeout
    Given I have a new subprocess that takes more than 5 seconds to run
    And I set a timeout of 5 seconds
    When I invoke the run method of said subprocess
    Then the subprocess should exit with exitcode 1

  Scenario: run simple subprocess that does not go past timeout
    Given I have a new subprocess that takes less than 5 seconds to run
    And I set a timeout of 5 seconds
    When I invoke the run method of said subprocess
    Then the subprocess should complete fine

