class Appointment < ApplicationRecord
  belongs_to :service
  enum :status, { pending: 0, accepted: 1, rejected: 2 }
end
