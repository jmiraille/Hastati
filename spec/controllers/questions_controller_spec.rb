require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  scenario "Get index" do
    expect(response).to have_http_status(200)
  end

end
