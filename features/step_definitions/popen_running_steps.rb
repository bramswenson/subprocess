Given /^I have a new subprocess that runs fast$/ do
  @popen = Subprocess::Popen.new('echo 1')
end

When /^I invoke the run method of said fast subprocess$/ do
  @popen.run
end

Then /^the subprocess should report running as false without waiting$/ do
  @popen.running?.should be_false
end

