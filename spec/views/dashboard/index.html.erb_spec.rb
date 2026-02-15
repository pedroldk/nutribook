require 'rails_helper'

RSpec.describe "dashboard/index.html.erb", type: :view do
  it 'renders nutritionist data attributes' do
    assign(:nutritionist, FactoryBot.create(:nutritionist, id: 42, name: 'Ana'))
    render

    expect(rendered).to include('Nutritionist Dashboard')
    expect(rendered).to include('Welcome, Ana')
    expect(rendered).to include('data-nutritionist-id="42"')
  end
end
