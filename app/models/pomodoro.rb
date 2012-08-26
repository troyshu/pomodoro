class Pomodoro < ActiveRecord::Base
  attr_accessible :finished, :length
  validates :user_id, presence: true
  validates_numericality_of :length, greater_than_or_equal_to: 0

  belongs_to :user

  #order by descending update date. when a pomodoro is finished, updated_at will be changed
  default_scope order: 'pomodoros.updated_at DESC'
end
