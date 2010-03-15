
Given /^I have a new subprocess that takes a long time to run$/ do 
  @popen = Subprocess::Popen.new('sleep 3 && exit 1')
  @popen.should_not be_nil
end

When /^I invoke the run method of said nonblocking subprocess$/ do
  start_time = Time.now.to_i
  @popen.run
  @total_time = Time.now.to_i - start_time
end

Then /^the subprocess should not block$/ do
  # this should pass if we backgrounded cause it shouldn't take more than 
  # 1 second to get here but the command should take 3 seconds to run
  @total_time.should be_close(0, 2) 
end

Then /^the subprocess should report its run status$/ do
  @popen.should respond_to(:is_running?)
end

Then /^the subprocess should support being waited on till complete$/ do
  @popen.wait
  @popen.status.exitstatus.should be_kind_of Numeric
end

Then /^the subprocess should have status info$/ do
  @popen.status.should be_a_kind_of Process::Status
end



