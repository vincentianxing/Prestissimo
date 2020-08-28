# == Schema Information
#
# Table name: courses
#
#  id                :integer          not null, primary key
#  dept              :string(255)
#  professor         :string(255)
#  proficiencies     :string(255)
#  building          :string(255)
#  room              :string(255)
#  cnum              :string(255)      default("")
#  crn               :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  csize             :integer
#  semester          :string(255)
#  mods              :integer
#  crmax             :float(24)
#  crmin             :float(24)
#  start_time        :time
#  end_time          :time
#  descrip           :text(65535)
#  semcrn            :string(255)
#  hubcourse_id      :integer
#  prereqs           :text(65535)
#  short_title       :string(255)
#  last_changed      :datetime
#  enroll            :integer
#  dean_consent      :boolean
#  instruct_consent  :boolean
#  section           :string(255)
#  format            :string(255)
#  std_letter        :boolean
#  p_np              :boolean
#  cr_ne             :boolean
#  audit             :boolean
#  days              :string(255)
#  xlist1            :string(255)
#  xlist2            :string(255)
#  xlist3            :string(255)
#  title             :string(255)
#  status            :string(255)      default("")
#  distributions     :string(255)
#  dept_long         :string(255)      default("")
#  full_course       :string(255)
#  xlist1_semcrn     :string(255)
#  xlist2_semcrn     :string(255)
#  xlist3_semcrn     :string(255)
#  prof_desc         :text(65535)
#  which_desc        :string(255)
#  new_desc_action   :string(255)
#  prof_note         :text(65535)
#  display_prof_note :boolean          default("1")
#  notify_profs      :string(255)
#  recent_edit       :string(255)
#  changed_fields    :string(255)
#  remote            :string(255)
#

require 'rails_helper'

describe Course do
	before { 
		@hubcourse = Hubcourse.new(id: 1)
		@course = @hubcourse.courses.new(dept: "CSCI", title: "Principles of Computer Science",
				      professor: "Geitz, Bob", proficiencies: "CD",
				      building: "King", room: "221", cnum: "214", crn: "532",
              		  semcrn: "532", hubcourse_id: "1") }

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
