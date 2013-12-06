require 'spec_helper'

describe Topic do
  let(:topic) { build(:topic) }

  subject { topic }

  it { should respond_to(:board_id) } 
  it { should respond_to(:name) }

 
  it { should be_valid }
  
  describe "when board_id is not present" do
    before { topic.board_id = nil }

    it { should_not be_valid }
  end  
  
  describe "#topic_name" do
    context "when nil" do
      before { topic.name = nil }

      it { should_not be_valid }
    end

     context "when not supplied" do
      before { topic.name = '' }

      it { should_not be_valid }
    end

    context "when too long" do
      before { topic.name = 'a' * 101 }

      it { should_not be_valid }
    end
  end
end
