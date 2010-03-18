require File.dirname(__FILE__) + '/../spec_helper.rb'

module Subprocess
  #describe Popen do
  
    describe "zero exit code subprocess with stdout" do
      before(:each) do
        @subprocess = Popen.new('echo 1')
        @subprocess.run
        @subprocess.wait
      end
      it "has an exitcode of 0" do
        @subprocess.status[:exitstatus].should == 0
      end
      it "has a runtime in seconds" do
        @subprocess.status[:run_time].should be_kind_of Numeric
      end
      # TODO: trackdown/report rspec bug with stdout
      #it "has a stdout of 1" do
      #  puts @subprocess.stdout
      #  @subprocess.stdout.should == '1'
      #end
      it "has an stderr of " do
        @subprocess.stderr.should == ''
      end
      it "has a numerical pid" do
        @subprocess.pid.should be_a_kind_of Numeric
      end
    end
  
  #end
end
