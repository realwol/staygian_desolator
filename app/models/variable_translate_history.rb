class VariableTranslateHistory < ActiveRecord::Base
	acts_as_paranoid
  has_many :variables

  scope :color_variable, ->{where(variable_from: 'color')}
  scope :size_variable, ->{where(variable_from: 'size')}
end
