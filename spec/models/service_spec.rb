require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'associations' do
    it 'belongs to a nutritionist' do
      s = FactoryBot.create(:service)
      expect(s.nutritionist).to be_present
    end

    it 'has many appointments' do
      s = FactoryBot.create(:service)
      a = FactoryBot.create(:appointment, service: s)
      expect(s.appointments).to include(a)
    end
  end
end
