Given /^I have a new subprocess that takes 3 seconds$/ do
  @popen = Subprocess::Popen.new('sleep 3')
end

When /^I wait on said 3 second process to complete$/ do
  @popen.run
  @popen.wait
end

Then /^the subprocess should report a run time of around 3 seconds$/ do
  @popen.run_time.should be_close(3, 0.2)
end

