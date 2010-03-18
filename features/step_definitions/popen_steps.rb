Given /^I have a new Subprocess instance initialized with "([^\"]*)"$/ do |command|
  @popen = Subprocess::Popen.new(command)
end

When /^I invoke the run method of said subprocess$/ do
  @popen.run
end

When /^I invoke the wait method of said subprocess$/ do
  @popen.wait
end

Then /^the instance should have a status attribute$/ do
  @popen.status.should be_a_kind_of Hash
end

Then /^the instances exit status is "([^\"]*)"$/ do |exitstatus|
  @popen.status[:exitstatus].should == exitstatus.to_i
end

Then /^the instances stdout matches "([^\"]*)"$/ do |stdout|
  @popen.stdout.should match(stdout)
end

Then /^the instances stderr matches "([^\"]*)"$/ do |stderr|
  @popen.stderr.should match(stderr)
end

Then /^the instance should have a numerical pid$/ do
  @popen.pid.should be_a_kind_of Fixnum
end



