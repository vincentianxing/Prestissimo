require 'spec_helper'

describe UsersHelper do
    describe "#getUrl" do
       it "should get url for CSCI" do
         helper.getUrl("CSCI").should eq("http://catalog.oberlin.edu/preview_program.php?catoid=35&poid=4384") 
       end

       it "should get url for MATH" do
        helper.getUrl("MATH").should eq("http://catalog.oberlin.edu/preview_program.php?catoid=35&poid=4429") 
      end

      it "should get url for the major" do
        helper.getUrl("STAT").should eq("http://catalog.oberlin.edu/preview_program.php?catoid=35&poid=4473") 
      end
    end
end