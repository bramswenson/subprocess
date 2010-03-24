Feature: Run simple remote subprocesses that has bad auth data

  As a ruby hacker
  I want to run system remote subprocesses that require auth data
  So they can be secure
  And actually remote :)

  Scenario: run simple remote subprocess with bad auth data
    Given I have a new remote subproces with invalid username
    And invalid password
    When I run the remote subprocess
    Then the remote subprocess should return an error

