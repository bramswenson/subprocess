require File.dirname(__FILE__) + '/../spec_helper.rb'

module Subprocess
  describe Popen do
  
    describe "zero exit code subprocess with stdout" do
      before(:each) do
        @subprocess = Popen.new('echo 1')
        @subprocess.run
      end
      it "has an exitcode of 0" do
        @subprocess.exitcode.should == 0
      end
      it "has a stdout of '1'" do
        @subprocess.stdout.should == '1'
      end
      it "has an stderr of ''" do
        @subprocess.stderr.should == ''
      end
      it "has a numerical pid" do
        @subprocess.pid.should be_a_kind_of Fixnum
      end
    end
  
  end
end
