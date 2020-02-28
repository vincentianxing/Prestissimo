class AddFieldsForNewDegreeSystem < ActiveRecord::Migration[4.2]
  def change
    # fix for differences between .com and .info
    #add_column :users, :second_major, :string

    # New fields from course file, flast and first.last@oberlin.edu
    add_column :professors, :userid, :string

    #NOT NEEDED
    #add_column :professors, :email, :string

    # we are now getting this info, so we will store it
    add_column :courses, :xlist1_semcrn, :string
    add_column :courses, :xlist2_semcrn, :string
    add_column :courses, :xlist3_semcrn, :string

    # Never used, not in the new data feed
    remove_column :courses, :page 
  end
end
