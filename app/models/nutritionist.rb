class Nutritionist < ApplicationRecord
  has_many :services, dependent: :destroy
end
