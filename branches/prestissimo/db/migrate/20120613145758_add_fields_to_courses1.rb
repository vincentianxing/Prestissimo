class AddFieldsToCourses1 < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :csize, :integer
    add_column :courses, :semester, :string
    add_column :courses, :mods, :integer, limit: 1
    add_column :courses, :crmax, :float
    add_column :courses, :crmin, :float
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
    add_column :courses, :start, :time
    add_column :courses, :end, :time
    add_column :courses, :descrip, :text
    add_column :courses, :sem_off, :binary, limit: 1
    add_column :courses, :days_off, :binary, limit: 1
  end
end
