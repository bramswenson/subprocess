Feature: Run simple remote subprocesses over ssh in ruby

  As a ruby hacker
  I want to run remote system subprocesses over ssh
  And I want to have them presented as objects
  So that I can get more data about said subprocesses
  And so that I can have more fine grained control of said subprocesses

  Scenario Outline: run simple remote subprocesses
    Given I have a new remote Subprocess instance initialized with "<command>"
    When I invoke the run method of said remote subprocess
    And I invoke the wait method of said remote subprocess
    Then the remote instances exit status is "<exitstatus>"
    And the remote instances stdout matches "<stdout>"
    And the remote instances stderr matches "<stderr>"
    And the remote instance should have a numerical pid

    Scenarios: zero exit code remote subprocesses with stdout
      | command | exitstatus | stdout | stderr |
      | echo 1 | 0 | 1 |  |

    Scenarios: zero exit code remote subprocesses with stderr
      | command | exitstatus | stdout | stderr |
      | echo 1 1>&2 | 0 |  | 1 |

    Scenarios: zero exit code remote subprocesses with stdout and stderr
      | command | exitstatus | stdout | stderr |
      | echo 1 && echo 1 1>&2 | 0 | 1 | 1 |

    Scenarios: nonzero exit code remote subprocesses with stdout
      | command | exitstatus | stdout | stderr |
      | echo 1 && exit 1 | 1 | 1 |  |
      | echo 1 && exit 2 | 2 | 1 |  |
      | echo 1 && exit 99 | 99 | 1 |  |

    Scenarios: nonzero exit code remote subprocesses with stderr
      | command | exitstatus | stdout | stderr |
      | echo 1 1>&2 && exit 1 | 1 |  | 1 |

    Scenarios: nonzero exit code remote subprocesses with stdout and stderr
      | command | exitstatus | stdout | stderr |
      | echo 1 && echo 1 1>&2 && exit 1 | 1 | 1 | 1 |


