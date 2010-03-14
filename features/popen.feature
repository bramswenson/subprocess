Feature: Run simple subprocesses in ruby

  As a ruby hacker
  I want to run system subprocesses 
  And I want to have them presented as objects
  So that I can get more data about said subprocesses
  And so that I can have more fine grained control of said subprocesses

  Scenario Outline: run simple subprocesses
    Given I have a new Subprocess instance initialized with "<command>"
    When I invoke the run method of said subprocess
    Then the instances exit code is "<exitcode>"
    And the instances stdout matches "<stdout>"
    And the instances stderr matches "<stderr>"
    And the instance should have a numerical pid

    Scenarios: zero exit code subprocesses with stdout
      | command | exitcode | stdout | stderr |
      | echo 1 | 0 | 1 |  |

    Scenarios: zero exit code subprocesses with stderr
      | command | exitcode | stdout | stderr |
      | echo 1 1>&2 | 0 |  | 1 |

    Scenarios: zero exit code subprocesses with stdout and stderr
      | command | exitcode | stdout | stderr |
      | echo 1 && echo 1 1>&2 | 0 | 1 | 1 |

    Scenarios: nonzero exit code subprocesses with stdout
      | command | exitcode | stdout | stderr |
      | echo 1 && exit 1 | 1 | 1 |  |

    Scenarios: nonzero exit code subprocesses with stderr
      | command | exitcode | stdout | stderr |
      | echo 1 1>&2 && exit 1 | 1 |  | 1 |

    Scenarios: nonzero exit code subprocesses with stdout and stderr
      | command | exitcode | stdout | stderr |
      | echo 1 && echo 1 1>&2 && exit 1 | 1 | 1 | 1 |


