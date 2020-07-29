# == Schema Information
#
# Table name: ahoy_visits
#
#  id               :bigint           not null, primary key
#  visit_token      :string(255)
#  visitor_token    :string(255)
#  user_id          :bigint
#  ip               :string(255)
#  user_agent       :text(65535)
#  referrer         :text(65535)
#  referring_domain :string(255)
#  landing_page     :text(65535)
#  browser          :string(255)
#  os               :string(255)
#  device_type      :string(255)
#  country          :string(255)
#  region           :string(255)
#  city             :string(255)
#  latitude         :float(24)
#  longitude        :float(24)
#  utm_source       :string(255)
#  utm_medium       :string(255)
#  utm_term         :string(255)
#  utm_content      :string(255)
#  utm_campaign     :string(255)
#  app_version      :string(255)
#  os_version       :string(255)
#  platform         :string(255)
#  started_at       :datetime
#
# Table Info
#
#| Field            | Type         | Null | Key | Default | Extra          |
#+------------------+--------------+------+-----+---------+----------------+
#| id               | bigint       | NO   | PRI | NULL    | auto_increment |
#| visit_token      | varchar(255) | YES  | UNI | NULL    |                |
#| visitor_token    | varchar(255) | YES  |     | NULL    |                |
#| user_id          | bigint       | YES  | MUL | NULL    |                |
#| ip               | varchar(255) | YES  |     | NULL    |                |
#| user_agent       | text         | YES  |     | NULL    |                |
#| referrer         | text         | YES  |     | NULL    |                |
#| referring_domain | varchar(255) | YES  |     | NULL    |                |
#| landing_page     | text         | YES  |     | NULL    |                |
#| browser          | varchar(255) | YES  |     | NULL    |                |
#| os               | varchar(255) | YES  |     | NULL    |                |
#| device_type      | varchar(255) | YES  |     | NULL    |                |
#| country          | varchar(255) | YES  |     | NULL    |                |
#| region           | varchar(255) | YES  |     | NULL    |                |
#| city             | varchar(255) | YES  |     | NULL    |                |
#| latitude         | float        | YES  |     | NULL    |                |
#| longitude        | float        | YES  |     | NULL    |                |
#| utm_source       | varchar(255) | YES  |     | NULL    |                |
#| utm_medium       | varchar(255) | YES  |     | NULL    |                |
#| utm_term         | varchar(255) | YES  |     | NULL    |                |
#| utm_content      | varchar(255) | YES  |     | NULL    |                |
#| utm_campaign     | varchar(255) | YES  |     | NULL    |                |
#| app_version      | varchar(255) | YES  |     | NULL    |                |
#| os_version       | varchar(255) | YES  |     | NULL    |                |
#| platform         | varchar(255) | YES  |     | NULL    |                |
#| started_at       | timestamp    | YES  |     | NULL    |                |

class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true
end
