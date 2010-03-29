
Given /^I have a new remote nonblocking subprocess that takes a long time to run$/ do
  @popen = Subprocess::PopenRemote.new('sleep 3 && exit 1', 'localhost', nil, 10, 'popen', :password => 'popen')
  @popen.should_not be_nil
end

When /^I invoke the run method of said nonblocking remote subprocess$/ do
  start_time = Time.now.to_i
  @popen.run
  @total_time = Time.now.to_i - start_time
end

Then /^the remote nonblocking subprocess should not block$/ do
  @total_time.should be_close(0, 2) 
end

Then /^the remote nonblocking subprocess should report its run status$/ do
  @popen.should respond_to(:running?)
end

Then /^the remote nonblocking subprocess should support being waited on till complete$/ do
  @popen.wait
end

Then /^the remote nonblocking subprocess should have status info$/ do
  @popen.status[:exitstatus].should be_kind_of Numeric
  @popen.status.should be_a_kind_of Hash
end


