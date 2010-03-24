Feature: Run a sequence of simple subprocesses in order

  As a ruby hacker
  I want to run a sequence of system subprocesses in a sequential order
  So I can run complex sequences of commands in a simple way

  Scenario: run a sequence of 2 sequential subprocess successfully
    Given I have a subprocess sequence with 2 subprocesses to run
    When I run the subprocesses sequence
    Then the subprocess sequence completes with success
    And the subprocess sequence has stdout for each subprocess
    And the subprocess sequence has stderr for each subprocess
    And the subprocess sequence has status for each subprocess

  Scenario: run a sequence of 2 sequential subprocess where the first fails
    Given I have a subprocess sequence with 2 subprocesses to run with a bad one first
    When I run the subprocesses sequence
    Then the subprocess sequence completes with failure

  Scenario: run a sequence of sequences
    Given I have a subprocess sequence with 2 subprocesses sequences
    When I run the sequence
    Then the sequences run just like any other subprocess
