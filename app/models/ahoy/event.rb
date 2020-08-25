# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null, primary key
#  visit_id   :bigint
#  user_id    :bigint
#  name       :string(255)
#  properties :json
#  time       :datetime
#
# Table desc
#
#| Field      | Type         | Null | Key | Default | Extra          |
#+------------+--------------+------+-----+---------+----------------+
#| id         | bigint       | NO   | PRI | NULL    | auto_increment |
#| visit_id   | bigint       | YES  | MUL | NULL    |                |
#| user_id    | bigint       | YES  | MUL | NULL    |                |
#| name       | varchar(255) | YES  | MUL | NULL    |                |
#| properties | json         | YES  |     | NULL    |                |
#| time       | timestamp    | YES  |     | NULL    |                |

class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true
end
