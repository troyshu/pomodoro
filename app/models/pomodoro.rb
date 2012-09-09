class Pomodoro < ActiveRecord::Base
  #taggable
  acts_as_taggable_on :tags

  #scope for pomodoros that are finished 
  scope :finished, where(finished: true)

  attr_accessible :finished, :length, :created_at, :updated_at
  validates :user_id, presence: true
  validates_numericality_of :length, greater_than_or_equal_to: 0

  belongs_to :user

  #order by descending update date. when a pomodoro is finished, updated_at will be changed
  default_scope order: 'pomodoros.updated_at DESC'

end
