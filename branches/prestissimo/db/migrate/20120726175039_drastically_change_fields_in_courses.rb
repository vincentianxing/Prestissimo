class DrasticallyChangeFieldsInCourses < ActiveRecord::Migration
  def up 
    add_column :courses, :prereqs, :text
    add_column :courses, :short_title, :string
    add_column :courses, :last_changed, :datetime
    add_column :courses, :enroll, :integer 
    add_column :courses, :dean_consent, :boolean
    add_column :courses, :instruct_consent, :boolean 
    add_column :courses, :section, :string 
    add_column :courses, :format, :string 
    add_column :courses, :attributes, :string 
    add_column :courses, :std_letter, :boolean
    add_column :courses, :p_np, :boolean
    add_column :courses, :cr_ne, :boolean
    add_column :courses, :audit, :boolean
    add_column :courses, :days, :string
    add_column :courses, :xlist1, :string
    add_column :courses, :xlist2, :string
    add_column :courses, :xlist3, :string
    add_column :courses, :title, :string
    remove_column :courses, :sem_off
    remove_column :courses, :nmax
    remove_column :courses, :nmin
    remove_column :courses, :smax
    remove_column :courses, :smin
    remove_column :courses, :hmax
    remove_column :courses, :hmin
    remove_column :courses, :emax
    remove_column :courses, :emin
    remove_column :courses, :cdmax
    remove_column :courses, :cdmin
    remove_column :courses, :cname
    remove_column :courses, :consent
    remove_column :courses, :days_off
  end

  def down 
    remove_column :courses, :prereqs
    remove_column :courses, :short_title
    remove_column :courses, :last_changed
    remove_column :courses, :enroll
    remove_column :courses, :dean_consent
    remove_column :courses, :instruct_consent
    remove_column :courses, :section
    remove_column :courses, :format
    remove_column :courses, :attributes
    remove_column :courses, :std_letter
    remove_column :courses, :p_np
    remove_column :courses, :cr_ne
    remove_column :courses, :audit
    remove_column :courses, :days
    remove_column :courses, :xlist1
    remove_column :courses, :xlist2
    remove_column :courses, :xlist3
    remove_column :courses, :title
    add_column :courses, :sem_off, :integer
    add_column :courses, :nmax, :float
    add_column :courses, :nmin, :float
    add_column :courses, :smax, :float
    add_column :courses, :smin, :float
    add_column :courses, :hmax, :float
    add_column :courses, :hmin, :float
    add_column :courses, :emax, :float
    add_column :courses, :emin, :float
    add_column :courses, :cdmax, :float
    add_column :courses, :cdmin, :float
    add_column :courses, :cname, :string
    add_column :courses, :consent, :boolean
    add_column :courses, :days_off, :string
  end
end
