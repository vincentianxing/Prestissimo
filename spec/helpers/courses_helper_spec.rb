require 'spec_helper'

describe CoursesHelper do
    describe "#find_by_crn" do
        it "should give the course" do
            c1 = Course.new(semcrn: "1234")
            c2 = Course.new(semcrn: "5678")
            cTest = [c1, c2]
            find_by_crn(cTest, "1234").should eq(c1)
        end

        it "should give nil" do
            find_by_crn("234", 345).should eq(nil)
        end
    end

    describe "#translate_mod" do
        it "should get First" do
            translate_mod(1).should eq("First")
        end

        it "should get Special" do
            translate_mod(4).should eq("Special")
        end

        it "should get nothing" do
            translate_mod("a").should eq("")
        end
    end

    describe "#translate_semester" do
        it "should get Fall session" do
            translate_semester("f20").should eq("Fall 2020")
        end

        it "should get Spring session" do
            translate_semester("s19").should eq("Spring 2019")
        end
    end

    describe "#current_semester" do
        it "should get current semester" do
            cTest1 = Setting.create(key: "current_semester", value: "testCourse")
            current_semester.should eq("testCourse")
        end
    end

    describe "#get_link" do
        it "should get course" do
            couTest = Course.new(title: "Introduction to Computer Science")
            get_link("obiemaps_course", couTest).should eq("http://obiemaps.oberlin.edu/courses/introduction-to-computer-science")
        end

        it "should get professor" do
            proTest = Professor.new(fname: "Robert", lname: "Geitz")
            get_link("obiemaps_prof", proTest).should eq("http://obiemaps.oberlin.edu/faculty/robert-geitz")
        end
    end

end