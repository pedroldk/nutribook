require 'rails_helper'

RSpec.describe "nutritionists/show.html.erb", type: :view do
  it 'renders basic placeholder content' do
    render
    expect(rendered).to include('Find me in app/views/nutritionists/show.html.erb')
  end
end
