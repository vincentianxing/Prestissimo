# == Schema Information
#
# Table name: courses
#
#  id               :integer(4)      not null, primary key
#  dept             :string(255)
#  professor        :string(255)
#  proficiencies    :string(255)
#  building         :string(255)
#  room             :string(255)
#  cnum             :string(255)     default("")
#  crn              :integer(4)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  csize            :integer(4)
#  semester         :string(255)
#  mods             :integer(1)
#  crmax            :float
#  crmin            :float
#  start_time       :time
#  end_time         :time
#  descrip          :text
#  semcrn           :string(255)
#  hubcourse_id     :integer(4)
#  prereqs          :text
#  short_title      :string(255)
#  last_changed     :datetime
#  enroll           :integer(4)
#  dean_consent     :boolean(1)
#  instruct_consent :boolean(1)
#  section          :string(255)
#  format           :string(255)
#  std_letter       :boolean(1)
#  p_np             :boolean(1)
#  cr_ne            :boolean(1)
#  audit            :boolean(1)
#  days             :string(255)
#  xlist1           :string(255)
#  xlist2           :string(255)
#  xlist3           :string(255)
#  title            :string(255)
#  status           :string(255)     default("")
#  distributions    :string(255)
#  dept_long        :string(255)     default("")
#  page             :integer(4)      default(0)
#

require 'spec_helper'

describe Course do
	before { @course = Course.new(dept: "CSCI", title: "Principles of Computer Science",
				      professor: "Geitz, Bob", proficiencies: "CD",
				      building: "King", room: "221", cnum: "214", crn: "532",
              semcrn: "532") }

	subject { @course }

	it { should respond_to(:dept) }
	it { should respond_to(:title) }
	it { should respond_to(:professor) }
	it { should respond_to(:building) }
	it { should respond_to(:proficiencies) }
	it { should respond_to(:room) }
	it { should respond_to(:cnum) }
	it { should respond_to(:crn) }
	it { should respond_to(:semcrn) }
	it { should respond_to(:created_at) }
	it { should respond_to(:updated_at) }

	it { should be_valid }

	describe "when crn is not present" do
		before { @course.crn = nil }
		it { should_not be_valid }
	end

	describe "when dept is not present" do
		before { @course.dept = nil }
		it { should_not be_valid }
	end

	describe "when course number is not present" do
		before { @course.cnum = nil }
		it { should_not be_valid }
	end

	describe "when professor is not present" do
		before { @course.professor = nil }
		it { should_not be_valid }
	end
end
