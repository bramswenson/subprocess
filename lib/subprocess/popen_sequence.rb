
module Subprocess
  class PopenSequence
    attr_reader :running, :complete, :incomplete, :failed, :status, :last

    def initialize(incomplete=[])
      @incomplete = incomplete
      @complete = []
      @failed = []
      @running = false
      @completed = false
      @status = nil
      @last = nil
    end

    def add_popen(popen)
      @incomplete << popen
    end
    alias :<< :add_popen

    def perform
      @running = true
      @failure = false
      @incomplete.each do |popen|
        popen.perform
        @status = popen.status
        @last = popen
        popen.status[:exitstatus] == 0 ? @complete << popen : (@failed << popen; break)
      end
      @incomplete = @incomplete - @complete
      @incomplete = @incomplete - @failed
      @running = false
      @completed = true
    end

    def completed?
      @completed
    end

  end
end

