require 'spec_helper'

describe CommentsHelper do
    describe "#translate_time" do
        it "should get readable am time" do
            timeTest1 = Time.new(2020, 1, 19)
            translate_time(timeTest1).should eq("1-19-2020 at 00:00 am EST")
        end

        it "should get readable pm time" do
            timeTest2 = Time.new(2020, 1, 19, 14, 5, 13)
            translate_time(timeTest2).should eq("1-19-2020 at 2:05 pm EST")
        end
    end
end