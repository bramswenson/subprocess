
Given /^I have a new remote subprocess that takes a long time to run$/ do 
  @popen = Subprocess::PopenRemote.new('sleep 3 && exit 1', 'localhost', 'popen', :password => 'popen')
  @popen.should_not be_nil
end

When /^I invoke the run method of said nonblocking remote subprocess$/ do
  start_time = Time.now.to_i
  @popen.run
  @total_time = Time.now.to_i - start_time
end

Then /^the remote subprocess should not block$/ do
  # this should pass if we backgrounded cause it shouldn't take more than 
  # 1 second to get here but the command should take 3 seconds to run
  @total_time.should be_close(0, 2) 
end

Then /^the remote subprocess should report its run status$/ do
  @popen.should respond_to(:is_running?)
end

Then /^the remote subprocess should support being waited on till complete$/ do
  @popen.wait
  @popen.status.exitstatus.should be_kind_of Numeric
end

Then /^the remote subprocess should have status info$/ do
  @popen.status.should be_a_kind_of Process::Status
end


Given /^I have a new remote Subprocess instance initialized with "([^\"]*)"$/ do |command|
  @popen_remote = Subprocess::PopenRemote.new(command, 'localhost', 'popen', :password => 'popen')
end

When /^I invoke the run method of said remote subprocess$/ do
  @popen_remote.run
end

When /^I invoke the wait method of said remote subprocess$/ do
  @popen_remote.wait
end

Then /^the remote instances exit status is "([^\"]*)"$/ do |exitstatus|
  @popen_remote.status.exitstatus.should == exitstatus.to_i
end

Then /^the remote instances stdout matches "([^\"]*)"$/ do |stdout|
  @popen_remote.stdout.should match(stdout)
end

Then /^the remote instances stderr matches "([^\"]*)"$/ do |stderr|
  @popen_remote.stderr.should match(stderr)
end

Then /^the remote instance should have a numerical pid$/ do
  @popen_remote.pid.should be_a_kind_of Fixnum
end

