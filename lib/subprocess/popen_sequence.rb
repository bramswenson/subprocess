
module Subprocess
  class PopenSequence
    attr_reader :running, :complete, :incomplete, :failed, :status

    def initialize(incomplete=[])
      @incomplete = incomplete
      @complete = []
      @failed = []
      @running = false
      @completed = false
      @status = nil
    end

    def add_popen(popen)
      @incomplete << popen
    end

    def perform
      @running = true
      @failure = false
      @incomplete.each do |popen|
        popen.run
        popen.wait
        popen.status[:exitstatus] == 0 ? @complete << popen : @failed << popen
        @status = popen.status
        break unless popen.status[:exitstatus] == 0
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

