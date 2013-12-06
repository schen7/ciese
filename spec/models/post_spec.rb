require 'spec_helper'

describe Post do
  let(:post) { build(:post) }

  subject { post }

  it { should respond_to(:topic_id) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:author) }

  it { should be_valid }

  describe "when topic_id is not present" do
    before { post.topic_id = nil }

    it { should_not be_valid }
  end

  describe "when author is not present" do
    before { post.author = nil }

    it { should_not be_valid }
  end

  describe "#post_title" do
    context "when nil" do
      before { post.title = nil }

      it { should_not be_valid }
    end

     context "when not supplied" do
      before { post.title = '' }

      it { should_not be_valid }
    end

    context "when too long" do
      before { post.title = 'a' * 101 }

      it { should_not be_valid }
    end
  end

end
