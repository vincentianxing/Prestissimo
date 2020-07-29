module SettingsHelper
  def get_semesters
    sems = Setting.get_val('semesters')
    @semesters = []
    sems.split('|').each do |semester|
      @semesters << semester
    end
    @semesters
  end
end
