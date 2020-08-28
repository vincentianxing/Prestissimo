require 'rails_helper'

describe "Course pages" do

	subject { page }

	describe "search page" do
		before { visit root_path }
		it { should have_title 'Search' }

		describe "with form filled in" do
			before do
				fill_in "cname", with: "Principles of Computer Science"
			end
			pending "'#{__FILE__} should return results' is not an accurate test"
			# TODO: Fix test
			# it "should return results" do
			# 	build :course
			# 	click_button "course_search"
			# 	should have_content("King")
			# end
		end

	end
end
