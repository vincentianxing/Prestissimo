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
#

class Course < ActiveRecord::Base
  include Comparable
  #Set of fields that can be included in an update when update_attributes is called
  #Any field not included here cannot be assigned with a call to update_attributes
  attr_accessible :conflict

  belongs_to :hubcourse
  has_and_belongs_to_many :professors
  has_one :syllabus
  
  # don't enter unless the following fields conform to specified expectations
  validates :crn, presence: true
  validates :dept, presence: true, length: { is: 4 }
  validates :semcrn, presence: true

  before_create :fix_gaps

  default_scope :order => "dept, cnum, section"

  def fix_gaps
    self.title = self.short_title if self.title.blank?
    self.short_title = self.title if self.short_title.blank?
    self.dept_long = self.dept if self.dept_long.blank?
  end

  def self.build(course_arr)
    c = Course.new

    # dept, number, section number, crn
    c.dept_long = course_arr[0] || ""
    c.dept = course_arr[1] || ""
    c.cnum = course_arr[2][0..2] || ""
    c.section = course_arr[3] || ""
    c.crn = course_arr[4]

    # modules
    case course_arr[5]
    when "Full Term"
      c.mods = 3
    when "First Module"
      c.mods = 1
    when "Second Module"
      c.mods = 2
    else
      c.mods = 4
    end
    c.format = course_arr[6] || ""

    # semester
    c.semester = Course.translate_semester(course_arr[7])

    # titles
    c.short_title = course_arr[8] || course_arr[9]
    c.title = course_arr[9] || c.short_title

    # professors (up to 3)
    c.professor = course_arr[10] || ""
    c.professor << ", #{course_arr[11]}" unless course_arr[11].blank?
    c.professor << ", #{course_arr[12]}" unless course_arr[12].blank?
    credits_ranged = false

    # credit hours
    case course_arr[13]
    when /(\d|\d\d|\d\.\d)/
      c.crmax = course_arr[13]
      c.crmin = course_arr[13]
    when /(\d|\d\.\d)\s-\s(\d|\d\.\d)/
      crs = course_arr[13].split(' - ')
      c.crmin = crs[0].to_f
      c.crmax = crs[1].to_f
      credits_ranged = true
    end

    # grades, p/np, cr/ne, audit
    case course_arr[14]
    when 'Y'
      c.std_letter = true
    else
      c.std_letter = false
    end
    case course_arr[15]
    when 'Y'
      c.cr_ne = true
    else
      c.cr_ne = false
    end
    case course_arr[16]
    when 'Y'
      c.p_np = true
    else
      c.p_np = false
    end
    case course_arr[17]
    when 'Y'
      c.audit = true
    else
      c.audit = false
    end
    
    # credit distributions
    c.distributions = ""
    case course_arr[18]
    when 'CNDP'
      if credits_ranged
	c.distributions << "#{c.crmin}-#{c.crmax}"
      else
	c.distributions << "#{c.crmax}"
      end
      c.distributions << 'CNDP'
    when 'SS12'
      if credits_ranged
	c.distributions << "#{c.crmin/2}-#{c.crmax/2}"
      else
	c.distributions << "#{c.crmax/2}"
      end
      c.distributions << 'SS' 
    when 'SSCI'
      if credits_ranged
	c.distributions << "#{c.crmin}-#{c.crmax}"
      else
	c.distributions << "#{c.crmax}"
      end
      c.distributions << 'SS'
    end
    case course_arr[19]
    when 'AR12'
      if credits_ranged
	c.distributions << ", #{c.crmin/2}-#{c.crmax/2}"
      else
	c.distributions << ", #{c.crmax/2}"
      end
      c.distributions << 'HU'
    when 'ARHU'
      if credits_ranged
	c.distributions << ", #{c.crmin}-#{c.crmax}"
      else
	c.distributions << ", #{c.crmax}"
      end
      c.distributions << 'HU'
    when 'DDHU'
      if credits_ranged
	c.distributions << ", #{c.crmin}-#{c.crmax}"
      else
	c.distributions << ", #{c.crmax}"
      end
      c.distributions << 'DDHU'
    end
    case course_arr[20]
    when 'NS12'
      if credits_ranged
	c.distributions << ", #{c.crmin/2}-#{c.crmax/2}"
      else
	c.distributions << ", #{c.crmax/2}"
      end
      c.distributions << 'NS'
    when 'NSMA'
      if credits_ranged
	c.distributions << ", #{c.crmin}-#{c.crmax}"
      else
	c.distributions << ", #{c.crmax}"
      end
      c.distributions << 'NS'
    end
    # clean out leading commas
    c.distributions = c.distributions[2..-1] if c.distributions[0] == ','

    # proficiencies
    c.proficiencies = ""
    c.proficiencies << 'CD' if course_arr[22] == 'Y'
    c.proficiencies << ',WR' if course_arr[23] == 'Y'
    c.proficiencies << ',QP-F' if course_arr[24] == 'QP-F'
    c.proficiencies << ',QP-H' if course_arr[24] == 'QP-H'
    c.proficiencies = c.proficiencies[1..-1] if c.proficiencies[0] == ','

    # consent
    if course_arr[25] == 'Y'
      c.instruct_consent = true
    else
      c.instruct_consent = false
    end
    if course_arr[26] == 'Y'
      c.dean_consent = true
    else
      c.dean_consent = false
    end

    # days
    c.days = course_arr[31] || ""

    # times
    unless course_arr[32].blank?
      c.start_time = "#{course_arr[32][0..1]}:#{course_arr[32][2..3]}"
    end
    unless course_arr[33].blank?
      c.end_time = "#{course_arr[33][0..1]}:#{course_arr[33][2..3]}"
    end

    # location
    c.building = course_arr[34] || ""
    c.room = course_arr[35] || ""

    # crosslists as DEPT_CNUM
    c.xlist1 = ""
    unless course_arr[37].blank? || course_arr[38].blank?
      c.xlist1 = "#{course_arr[37]} #{course_arr[38]}"
    end
    c.xlist2 = ""
    unless course_arr[40].blank? || course_arr[41].blank?
      c.xlist2 = "#{course_arr[40]} #{course_arr[41]}"
    end
    c.xlist3 = ""
    unless course_arr[43].blank? || course_arr[44].blank?
      c.xlist3 = "#{course_arr[43]} #{course_arr[44]}"
    end

    # description and prereqs
    c.descrip = course_arr[46] || ""
    c.prereqs = course_arr[47] || ""

    # semcrn
    c.semcrn = "#{c.semester}_#{c.crn}"

    # set updated time
    c.last_changed = DateTime.now

    c
  end

  def update_size(csize,enroll,page)
    self.csize = csize
    self.enroll = enroll
    # need to handle assignment of page to courses with duplicate semcrns
    #self.page = page
  end
  
  def sever_relationships
	  self.professors.clear
	  #self.syllabus.clear
	  self.hubcourse = nil
  end

  def generate_relationships
    hubid = "#{self.dept} #{self.cnum}"
    hc = Hubcourse.find_by_hub_id(hubid)
    unless hc
      hc = Hubcourse.new
      hc.hub_id = hubid
      hc.cname = self.title
      hc.cnum = self.cnum
      hc.save
    end 
    hc.courses << self
    profs = self.professor.split(", ")
    profs.each do |a_prof|
      case a_prof
      when "A&S Staff", "Con Staff", "OCEAN Staff"
	next
      else
	fname = ""
	lname = ""
	name_arr = a_prof.split(" ")
	fname = name_arr.delete_at(0)
	name_arr.each do |part|
	  lname << part + ' '
	end
	lname.strip!
	prof = Professor.where(fname: fname, lname: lname)
	if prof.size > 0
	  prof = prof[0]
	else
	  prof = nil
	end
	unless prof
	  prof = Professor.new
	  prof.fname = fname
	  prof.lname = lname
	  prof.save
	end
	self.professors << prof
      end
    end
  end

  def cancel
    self.status = "cancelled"
  end

  def get_module 
    ret = ""
    case self.mods
    when 1
      ret = "First"
    when 2
      ret = "Second"
    when 3
      ret = "Full Semester"
    else
      ret = "Special"
    end
    ret
  end

  def self.text_semester(semester)
    s = "Fall" if semester[0] == "f"
    s = "Spring" if semester[0] == "s"
    s << " 20#{semester[1..2]}"
  end

  def self.translate_semester(year_month)
    year = year_month[2..3]
    month = year_month[4..5]
    sem = ""
    case month
    when "09"
      sem = "f"
    when "02"
      sem = "s"
    end
    sem << year
    sem
  end

  #Overiding comparaison operator so spring semesters will come before fall semesters when
  #comparing two course objects
  def <=>(other)
    if self.semester.at(0) == "f"
      sem1 = self.semester[1..self.semester.length] + "9"
    else
      sem1 = self.semester[1..self.semester.length] + "2"
    end
    if other.semester.at(0) == "f"
      sem2 = other.semester[1..other.semester.length] + "9"
    else
      sem2 = other.semester[1..other.semester.length] + "2"
    end
    if sem1.to_i < sem2.to_i
      return 1
    elsif sem1.to_i > sem2.to_i
      return -1
    else 
      return 0
    end

  end
end
