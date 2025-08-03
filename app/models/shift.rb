class Shift < ApplicationRecord
  belongs_to :staff
  
  validates :start_time, presence: { message: "出勤日を選択してください" }
  validates :staff_id, presence: { message: "スタッフを選択してください" }
  
  scope :for_date, ->(date) { where(start_time: date.beginning_of_day..date.end_of_day) }
  scope :for_month, ->(date) { where(start_time: date.beginning_of_month..date.end_of_month) }
end
