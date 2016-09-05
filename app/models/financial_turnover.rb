class FinancialTurnover < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'creater_id'

  scope :income_turnover, -> {where(turnover_type: 1)}
  scope :expand_turnover, -> {where(turnover_type: 2)}

  def self.latest_turnorver
    FinancialTurnover.order('date inc').first
  end
end
