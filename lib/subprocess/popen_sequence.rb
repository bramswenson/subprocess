
module Subprocess
  class PopenSequenceError < StandardError; end
  class PopenSequence
    require 'forwardable'
    extend Forwardable
    attr_reader :running, :queue, :complete, :incomplete, :failed

    def_delegators :@last, :stdout, :stderr, :status

    def initialize(queue=[])
      @queue = queue
      @incomplete = queue
      @complete = []
      @failed = []
      @running = false
      @completed = false
      @last = nil
    end

    def include?(item)
      @queue.include?(item)
    end

    def [](index)
      @queue[index]
    end

    def add_popen(popen)
      raise PopenSequenceError, 
        "appending a completed sequence is not allowed" if @completed
      @incomplete << popen
    end
    alias :<< :add_popen

    def perform
      @running = true
      @failure = false
      @queue.each do |popen|
        @last = popen
        popen.perform
        popen.status[:exitstatus] == 0 ? @complete << popen : 
                                        (@failed << popen; break)
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

