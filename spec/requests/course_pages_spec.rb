require 'spec_helper'

describe "Course pages" do

	subject { page }

	describe "search page" do
		before { visit root_path }
		it { should have_selector('title', text: 'Search') }

		describe "with form filled in" do
			before do
				fill_in "cname", with: "Principles of Computer Science"
			end

			it "should return results" do
				click_button "Search"
				should have_content("King")
			end
		end

	end
end
