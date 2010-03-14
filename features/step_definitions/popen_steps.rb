Given /^I have a new Subprocess instance initialized with "([^\"]*)"$/ do |command|
  @subprocess = Subprocess::Popen.new(command)
end

When /^I invoke the run method of said subprocess$/ do
  @subprocess.run
end

Then /^the instances exit code is "([^\"]*)"$/ do |exitcode|
  @subprocess.exitcode.should == exitcode.to_i
end

Then /^the instances stdout matches "([^\"]*)"$/ do |stdout|
  @subprocess.stdout.should match(stdout)
end

Then /^the instances stderr matches "([^\"]*)"$/ do |stderr|
  @subprocess.stderr.should match(stderr)
end

Then /^the instance should have a numerical pid$/ do
  @subprocess.pid.should be_a_kind_of Fixnum
end


