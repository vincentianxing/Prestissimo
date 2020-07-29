# == Schema Information
#
# Table name: reports
#
#  id                 :integer(4)      not null, primary key
#  title              :string(255)
#  body               :text
#  reportable_id      :integer(4)
#  reportable_type    :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  response           :text
#  admin_email        :string(255)
#  resolved           :boolean(1)      default(FALSE)
#  user_id            :integer(4)
#  reportable_content :text
#  locked_by          :string(255)
#  reported_id        :integer(4)
#

class Report < ApplicationRecord
  validates :body, presence: true
  validates :user_id, presence: true
  validates :title, presence: true

  # A Report is filed by a User
  belongs_to :user
  # This is what allows multiple object to be reportable
  # - report has many parents
  belongs_to :reportable, polymorphic: true

  def self.build_report(reportable, reporter, title, body)
    r = Report.new
    r.user = reporter
    r.reportable_type = reportable.class.base_class.name
    r.reportable_id = reportable.id
    case r.reportable_type
    when 'Comment'
      handle = Handle.find_by_username(reportable.handle)
      User.all.each do |u|
        r.reported_id = u.id if u.handlekey == handle.handlekey
      end
    when 'Handle'
      User.all.each do |u|
        r.reported_id = u.id if u.handlekey == reportable.handlekey
      end
    when 'User'
      r.reported_id = reportable.id
    end
    r.reportable_content = reportable.inspect.to_s
    r.body = body
    r.title = title
    r.response = ''
    r
  end

  def resolve(admin, response)
    self.admin_email = admin.email
    self.response = DateTime.now.to_s + "\n" + response + "\n\n"
    self.resolved = true
  end

  def lock(name)
    self.locked_by = name
  end

  def unlock
    self.locked_by = nil
  end

  def unresolve(admin, _response)
    self.response = response + DateTime.now.to_s + 'n' + 'response' + 'nn'
    self.admin_email = admin.email
    logger.debug 'DDDDDD' + response
  end

  def reported
    User.find(reported_id)
  end

  def duplicate?
    # if a report exists by this user on this object, and the object has not been changed, this is a duplicate
    report = Report.where(reportable_type: reportable_type, reportable_id: reportable_id, user_id: user_id)
    report.!empty? && report.last.created_at > reportable_type.constantize.find(reportable_id).updated_at
  end
end
