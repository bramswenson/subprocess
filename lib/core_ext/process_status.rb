
module Process
  class Status
    def to_hash
      { :exited? => exited?, :exitstatus => exitstatus, :pid => pid, 
        :stopped? => stopped?, :stopsig => stopsig, :success? => success?,
        :termsig => termsig, :timed_out? => false }
    end
    def to_json
      to_hash.to_json
    end
  end
end

