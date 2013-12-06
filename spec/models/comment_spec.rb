require 'spec_helper'

describe Comment do
  let(:comment) { build(:comment) }
  
  subject { comment }

  it { should respond_to(:post_id) }
  it { should respond_to(:content) }
  it { should respond_to(:author) }

  it { should be_valid }
  
  describe "when post_id is not present" do
    before { comment.post_id = nil }

    it { should_not be_valid }
  end

  describe "when author is not present" do
    before { comment.author = nil }

    it { should_not be_valid }
  end
end
