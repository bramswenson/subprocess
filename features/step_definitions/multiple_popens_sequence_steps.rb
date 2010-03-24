Given /^I have a subprocess sequence with 2 subprocesses to run$/ do
  @seq = Subprocess::PopenSequence.new
  @seq.add_popen(Subprocess::Popen.new('echo "popen 1"'))
  @seq.add_popen(Subprocess::Popen.new('echo "popen 2"'))
end

When /^I run the subprocesses sequence$/ do
  @seq.perform
end

Then /^the subprocess sequence completes with success$/ do
  @seq.status[:exitstatus].should == 0
  @seq.completed?.should be_true
  @seq.complete.length.should == 2
  @seq.incomplete.length.should == 0
  @seq.failed.length.should == 0
end

Then /^the subprocess sequence has stdout for each subprocess$/ do
  @seq.complete.each do |popen|
    popen.stdout.should_not == ""
  end
end

Then /^the subprocess sequence has stderr for each subprocess$/ do
  @seq.complete.each do |popen|
    popen.stderr.should == ""
  end
end

Then /^the subprocess sequence has status for each subprocess$/ do
  @seq.complete.each do |popen|
    popen.status.should be_kind_of Hash
  end
end

Given /^I have a subprocess sequence with 2 subprocesses to run with a bad one first$/ do
  @seq = Subprocess::PopenSequence.new
  @seq.add_popen(Subprocess::Popen.new('exit 1'))
  @seq.add_popen(Subprocess::Popen.new('echo "popen 2"'))
end

Then /^the subprocess sequence completes with failure$/ do
  @seq.incomplete.length.should == 1
  @seq.failed.length.should == 1
  @seq.complete.length.should == 0
  @seq.status[:exitstatus].should_not == 0
end

