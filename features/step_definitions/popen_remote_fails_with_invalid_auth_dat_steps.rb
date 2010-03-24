Given /^I have a new remote subproces with invalid username$/ do
  @popen_remote = Subprocess::PopenRemote.new('tail -n50 /var/log/daemon.log',
                    'localhost', 'someadminnamethatshouldneverexist',
                    :password => 'somebadpasswordnooneuses')
end

Given /^invalid password$/ do
  # by leaving this empty its an auto pass and really just serves to make feature read better
end

When /^I run the remote subprocess$/ do
  @popen_remote.run
end

Then /^the remote subprocess should return an error$/ do
  @popen_remote.wait
  @popen_remote.stderr.should_not be_nil
end

