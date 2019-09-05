require 'spec_helper'

describe "Static Pages" do

	subject { page }

	describe "About page" do
		before { visit about_path }
		it { should have_selector('h1', text: 'About Us') }
		it { should have_selector('title', text: full_title('About Us')) }
		it { should have_link('Help') }
		it "clicks on the help link" do
			click_link('Help')
		end
	end

	describe "Help" do
		before { visit help_path }

		it { should have_selector('h1', text: 'Help') }
		it { should have_selector('title', text: full_title('Help')) }
		it { should have_link('About') }
		it "clicks on the about link" do
			click_link('About')
		end
	end

end
