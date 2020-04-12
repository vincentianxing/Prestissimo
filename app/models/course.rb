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
#  full_course      :string(255)
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

class Course < ApplicationRecord
  include Comparable

  belongs_to :hubcourse
  has_and_belongs_to_many :professors, join_table: "courses_professors"
  has_one :syllabus

  # don't enter unless the following fields conform to specified expectations
  validates :crn, presence: true
  validates :dept, presence: true, length: { is: 4 }
  validates :semcrn, presence: true
  validates :cnum, presence: true
  validates :professor, presence: true

  before_create :fix_gaps

  default_scope { order(:dept, :cnum, :section) }
  # allow for setting query sort by order
  #  def self.set_scope(order)
  #    default_scope :order => order
  #  end

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
    c.cnum = course_arr[2][0..2] || "" # TODO: Check to see if we can include letters in cnum
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
    c.professor << ", #{course_arr[13]}" unless course_arr[13].blank?
    c.professor << ", #{course_arr[14]}" unless course_arr[14].blank?

    # credit hours

    c.crmax = 0.0 # default to 0 just in case the field is blank.
    c.crmin = 0.0 #
    credits_ranged = false # for use in distributions field below.
    case course_arr[15]
    when /^\s*(\d|\d\d|\d\.\d)\s*$/ # line start, optional whitespace, (single digit|double digit|digit.digit), optional whitespace, new line
      c.crmax = course_arr[15].to_f
      c.crmin = course_arr[15].to_f
    when /^\s*(\d|\d\.\d)\s*-\s*(\d|\d\.\d)\s*$/ # line start, optional whitespace (single digit|digit.digit)whitespace-whitespace(single digit|digit.digit), optional whitespace, new line
      crs = course_arr[15].split("-")
      c.crmin = crs[0].strip.to_f
      c.crmax = crs[1].strip.to_f
      credits_ranged = true
    end

    # grades, p/np, cr/ne, audit
    case course_arr[16]
    when "Y"
      c.std_letter = true
    else
      c.std_letter = false
    end
    case course_arr[17]
    when "Y"
      c.cr_ne = true
    else
      c.cr_ne = false
    end
    case course_arr[18]
    when "Y"
      c.p_np = true
    else
      c.p_np = false
    end
    case course_arr[19]
    when "Y"
      c.audit = true
    else
      c.audit = false
    end

    # credit distributions
    c.distributions = ""
    cndp_set = ddhu_set = false

    # Handle SSCI credits
    case course_arr[20]
    when "CNDP"
      # CNDP is handled in the humanities statement below
      cndp_set = true
    when "SS12"
      if credits_ranged
        c.distributions << "#{c.crmin / 2}-#{c.crmax / 2}"
      else
        c.distributions << "#{c.crmax / 2}"
      end
      c.distributions << "SS"
    when "SSCI"
      if credits_ranged
        c.distributions << "#{c.crmin}-#{c.crmax}"
      else
        c.distributions << "#{c.crmax}"
      end
      c.distributions << "SS"
    end

    # Handle NSCI credits
    case course_arr[22]
    when "NS12"
      if credits_ranged
        c.distributions << ", #{c.crmin / 2}-#{c.crmax / 2}"
      else
        c.distributions << ", #{c.crmax / 2}"
      end
      c.distributions << "NS"
    when "NSMA"
      if credits_ranged
        c.distributions << ", #{c.crmin}-#{c.crmax}"
      else
        c.distributions << ", #{c.crmax}"
      end
      c.distributions << "NS"
    end

    # Handle humanities credits
    case course_arr[21]
    when "AR12"
      if credits_ranged
        c.distributions << ", #{c.crmin / 2}-#{c.crmax / 2}"
      else
        c.distributions << ", #{c.crmax / 2}"
      end
      c.distributions << "HU"
    when "ARHU"
      if credits_ranged
        c.distributions << ", #{c.crmin}-#{c.crmax}"
      else
        c.distributions << ", #{c.crmax}"
      end
      c.distributions << "HU"
    when "DDHU"
      # DDHU is handled below
      ddhu_set = true
    end

    # Handle CNDP and DDHU con humanities credits
    if cndp_set || ddhu_set
      unless c.distributions[-2..-1] == "HU"
        if credits_ranged
          c.distributions << ", #{c.crmin}-#{c.crmax}"
        else
          c.distributions << ", #{c.crmax}"
        end
        c.distributions << "HU"
      end
      c.distributions << " ["
      if cndp_set
        c.distributions << "CNDP"
      end
      if ddhu_set
        if cndp_set
          c.distributions << ", "
        end
        c.distributions << "DDHU"
      end
      c.distributions << "]"
    end

    # clean out leading commas
    c.distributions = c.distributions[2..-1] if c.distributions[0] == ","

    # set full course, half course, or co-curricular
    if course_arr[23] == "FC"
      c.full_course = "Full Course"
    end
    if course_arr[24] == "HC"
      c.full_course = ", Half Course"
    end
    if course_arr[25] == "CC"
      c.full_course = ", Co-Curricular"
    end
    # prevent nil errors#TODO#
    if c.full_course.nil?
      c.full_course = ""
    end
    c.full_course = c.full_course[2..-1] if c.full_course[0] == ","

    #proficiencies for new system
    c.proficiencies = ""
    c.proficiencies << "CD" if course_arr[30] == "Y"
    c.proficiencies << ",QFR" if course_arr[28] == "QFR"
    c.proficiencies << ",WAdv" if course_arr[27] == "WADV"
    c.proficiencies << ",WInt" if course_arr[26] == "WINT"
    #c.proficiencies << ',WR' if course_arr[28] == 'Y'
    #c.proficiencies << ',QP-F' if course_arr[29] == 'QP-F'
    #c.proficiencies << ',QP-H' if course_arr[29] == 'QP-H'
    c.proficiencies = c.proficiencies[1..-1] if c.proficiencies[0] == ","

    # consent for the new system
    if course_arr[31] == "Y"
      c.instruct_consent = true
    else
      c.instruct_consent = false
    end
    if course_arr[32] == "Y"
      c.dean_consent = true
    else
      c.dean_consent = false
    end

    # days
    c.days = course_arr[35] || ""

    # times
    unless course_arr[35].blank?
      c.start_time = "#{course_arr[36][0..1]}:#{course_arr[36][2..3]}"
      unless course_arr[36].blank?
        c.end_time = "#{course_arr[37][0..1]}:#{course_arr[37][2..3]}"
      end
    end

    # location
    c.building = course_arr[38] || ""
    c.room = course_arr[39] || ""

    # crosslists as DEPT_CNUM
    c.xlist1 = ""
    unless course_arr[40].blank? || course_arr[41].blank?
      c.xlist1 = "#{course_arr[40]} #{course_arr[41]}"
    end
    c.xlist1_semcrn = "#{c.semester}_#{course_arr[42]}" unless course_arr[42].blank? #TODO
    c.xlist2 = ""
    unless course_arr[43].blank? || course_arr[44].blank?
      c.xlist2 = "#{course_arr[43]} #{course_arr[44]}"
    end
    c.xlist2_semcrn = "#{c.semester}_#{course_arr[45]}" unless course_arr[45].blank? #TODO
    c.xlist3 = ""
    unless course_arr[46].blank? || course_arr[47].blank?
      c.xlist3 = "#{course_arr[46]} #{course_arr[47]}"
    end
    c.xlist3_semcrn = "#{c.semester}_#{course_arr[48]}" unless course_arr[48].blank? #TODO

    # description and prereqs
    c.descrip = course_arr[49] || ""
    c.prereqs = course_arr[50] || ""

    # semcrn
    c.semcrn = "#{c.semester}_#{c.crn}"

    # set which_desc
    c.which_desc = "default"

    # set updated time
    c.last_changed = DateTime.now

    c
  end

  def update_size(csize, enroll)
    self.csize = csize
    self.enroll = enroll
    # need to handle assignment of page to courses with duplicate semcrns
  end

  def sever_relationships
    self.professors.clear
    #self.syllabus.clear
    self.hubcourse = nil
  end

  def generate_relationships(prim_instructor = "", prim_userid = "", prim_email = "")
    hubid = "#{self.dept} #{self.cnum}"
    hc = Hubcourse.find_by_hub_id(hubid)
    unless hc
      hc = Hubcourse.new
      hc.hub_id = hubid
      hc.cname = self.title
      hc.cnum = self.cnum
      hc.save
      puts "Hubcourse #{hubid} created"
    end
    hc.courses << self

    d = Department.find_by_dept(hc.hub_id[0..3])

    # If the hubcourse is new, it needs a department
    unless hc.department
      # Make a new department is need be
      unless d
        d = Department.new
        d.dept = hc.hub_id[0..3]
        d.dept_long = hc.courses.first.dept_long
        if d.save
          puts "Department #{d.dept} created"
        end
      end
      d.hubcourses << hc
    end

    profs = self.professor.split(", ")
    profs.each do |a_prof|
      case a_prof
      when "A&S Staff", "Con Staff", "OCEAN Staff", "Staff", /^\s*$/
        next
      else
        userid = prim_userid if a_prof == prim_instructor
        email = prim_email if a_prof == prim_instructor
        fname = ""
        lname = ""
        name_arr = a_prof.split(" ")
        fname = name_arr.delete_at(0)
        name_arr.each do |part|
          lname << part + " "
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
          prof.userid = userid #TODO
          prof.email = email #TODO
          prof.save
        else
          #TODO#adding in data for existing professors, consider removing
          prof.userid = userid unless userid.blank?
          prof.email = email unless email.blank?
          prof.save
        end

        self.professors << prof
        prof.departments << d unless prof.departments.include? d
      end
    end
  end

  def cancel
    self.status = "cancelled"
    self.changed_fields ||= ""
    self.changed_fields << "|" unless self.changed_fields.blank?
    self.changed_fields << "cancelled"
  end

  def notify_prof_set(profemail)
    puts "premodel change: #{self.notify_profs}"
    self.notify_profs ||= ""
    puts self.notify_profs
    unless self.notify_profs.include?(profemail)
      self.notify_profs << "|" unless self.notify_profs.blank?
      self.notify_profs << profemail
    end
    self.save
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

  def self.csv_headers
    ["CRN", "No.", "Dept.", "Semester", "Course Name", "Instructor", "Days", "Start Time", "End Time", "Room", "Enroll.", "Size", "Profic.", "Section", "Format", "Module", "Credits", "Distributions", "Full/Half", "P/NP", "X-Listings"]
  end

  def self.to_csv_row(c)
    row = [c.crn, c.cnum, c.dept]
    row << text_semester(c.semester)
    row << c.short_title
    if c.professors.size > 0
      profs = []
      c.professors.each do |p|
        profs << "#{p.fname} #{p.lname}"
      end
      row << profs.join(", ")
    else
      row << c.professor
    end
    row << c.days
    if c.start_time != nil
      row << c.start_time.strftime("%I:%M %p")
    else
      row << ""
    end
    if c.end_time != nil
      row << c.end_time.strftime("%I:%M %p")
    else
      row << ""
    end
    if c.building.blank? && c.room.blank?
      row << ""
    elsif c.building.blank?
      row << c.room
    elsif c.room.blank?
      row << c.building
    else
      row << "#{c.building} #{c.room}"
    end
    row << c.enroll
    row << c.csize
    row << c.proficiencies.gsub("-", "").split(",").sort.join("-")
    row << c.section
    row << c.format
    row << c.get_module
    if c.crmax != c.crmin
      row << "#{c.crmin} - #{c.crmin}"
    else
      row << c.crmax
    end
    unless c.distributions.blank?
      row << c.distributions
    else
      row << ""
    end
    unless c.full_course.blank?
      row << c.full_course
    else
      row << ""
    end
    if c.p_np
      if c.std_letter
        row << "Available"
      else
        row << "Only"
      end
    else
      row << ""
    end
    xlist = []
    xlist << c.xlist1 unless c.xlist1.blank?
    xlist << c.xlist2 unless c.xlist2.blank?
    xlist << c.xlist3 unless c.xlist3.blank?
    if xlist.size > 0
      row << xlist.join(", ")
    else
      row << ""
    end
    row
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
      d = self.dept <=> other.dept
      return d unless d == 0
      n = self.cnum <=> other.cnum
      return n unless n == 0
      return self.section <=> other.section
    end
  end
end

# 0 	dept desc
# 1 	dept code
# 2 	crse
# 3 	sect
# 4 	crn
# 5 	module
# 6 	lect/lab/disc
# 7 	term
# 8 	title
# 9 	long title
# 10	prim instructor
# 11	userid
# 12	email
# 13	2nd instructor
# 14	3rd instructor
# 15	hours
# 16	standard letter
# 17	credit/no entry
# 18	pass/no pass
# 19	audit
# 20	ssci
# 21	arhu
# 22	nsci
# 23	fc
# 24	hc
# 25	cc
# 26	wint
# 27	wadv
# 28	qfr
# 29	ex
# 30	cul div
# 31	instr consent
# 32	dean consent
# 33	major
# 34	level
# 35	days
# 36	start time
# 37	end time
# 38	bldg code
# 39	room code
# 40	xlist dept 1
# 41	xlist crse 1
# 42	xlist crn 1
# 43	xlist dept 2
# 44	xlist crse 2
# 45	xlist crn 2
# 46	xlist dept 3
# 47	xlist crse 3
# 48	xlist crn 3
# 49	text narrative
# 50	prereqs and notes
