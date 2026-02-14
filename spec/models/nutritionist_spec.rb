require 'rails_helper'

RSpec.describe Nutritionist, type: :model do
  describe 'associations' do
    it 'has many services' do
      n = FactoryBot.create(:nutritionist)
      s = FactoryBot.create(:service, nutritionist: n)

      expect(n.services).to include(s)
    end

    it 'destroys dependent services' do
      n = FactoryBot.create(:nutritionist)
      FactoryBot.create(:service, nutritionist: n)

      expect { n.destroy }.to change { Service.count }.by(-1)
    end
  end
end
