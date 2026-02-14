require 'rails_helper'

RSpec.describe "nutritionists/index.html.erb", type: :view do
  it 'renders the react root' do
    render
    expect(rendered).to include('Find me in app/views/nutritionists/index.html.erb')
    expect(rendered).to include('id="react-root"')
  end
end
