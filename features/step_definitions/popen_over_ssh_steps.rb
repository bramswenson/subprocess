
Given /^I have a new remote Subprocess instance initialized with "([^\"]*)"$/ do |command|
  @popen_remote = Subprocess::PopenRemote.new(command, 'localhost', 'popen', 10, :password => 'popen')
end

When /^I invoke the run method of said remote subprocess$/ do
  @popen_remote.run
end

When /^I invoke the wait method of said remote subprocess$/ do
  @popen_remote.wait
end

Then /^the remote instances exit status is "([^\"]*)"$/ do |exitstatus|
  @popen_remote.status[:exitstatus].should == exitstatus.to_i
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

