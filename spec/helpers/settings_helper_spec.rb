require 'spec_helper'

describe SettingsHelper do
    describe "#get_semesters" do
        it "should get semesters" do
            @setTest = Setting.new(key: "semesters", value: "test1|test2")
            get_semesters.should eq(["test1", "test2"])
        end
    end
end