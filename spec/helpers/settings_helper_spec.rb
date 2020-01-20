require 'spec_helper'

describe SettingsHelper do
    describe "#get_semesters" do
        it "should get two semesters" do
            setTest = Setting.create(key: "semesters", value: "test1|test2")
            get_semesters.should eq(["test1", "test2"])
        end

        it "should get one semesters" do
            setTest = Setting.create(key: "semesters", value: "test1")
            get_semesters.should eq(["test1"])
        end
    end
end