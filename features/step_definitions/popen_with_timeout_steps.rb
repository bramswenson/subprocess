Given /^I have a new subprocess that takes more than 5 seconds to run$/ do
  @popen = Subprocess::Popen.new('sleep 10', 5)
end

Given /^I have a new subprocess that takes less than 5 seconds to run$/ do
  @popen = Subprocess::Popen.new('sleep 1', 5)
end

When /^I invoke the run method of said subprocess with timeout$/ do
  @popen.run
  @popen.wait
end

Given /^I set a timeout of 5 seconds$/ do
end

Then /^the subprocess should exit with exitcode 1$/ do
  @popen.status[:exitstatus].should == 1
end

Then /^the subprocess should complete fine$/ do
  @popen.running?.should be_false
end

