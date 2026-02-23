require 'rails_helper'

RSpec.describe "SittingSessions", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "トップページにアクセスできること" do
    visit root_path
    expect(page).to have_content "座りすぎは喫煙と同等に身体に悪影響を及ぼすとされています"
  end

  
end
