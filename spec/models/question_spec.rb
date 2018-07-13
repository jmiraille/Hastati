require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) {create :question}

  it "has a valid factory" do
    expect(question).to be_valid
  end

  it "require a content" do
    question.content = nil
    expect(question).to_not be_valid
  end
end
