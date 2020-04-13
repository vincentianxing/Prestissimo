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
