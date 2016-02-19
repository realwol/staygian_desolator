class VariableTranslateHistory < ActiveRecord::Base
	acts_as_paranoid
  has_many :variables

  belongs_to :user

  scope :color_variable, ->{where(variable_from: 'color')}
  scope :size_variable, ->{where(variable_from: 'size')}
end
