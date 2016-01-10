class VariableTranslateHistory < ActiveRecord::Base
	acts_as_paranoid
  has_many :variables
end
