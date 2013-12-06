require 'spec_helper'

describe Board do
  let(:board) { build(:board) }

  subject { board }

  it { should respond_to(:name) }

  it { should be_valid }

  describe "#board_name" do
    context "when nil" do
      before { board.name = nil }
      
      it { should_not be_valid }
    end

    context "when not supplied" do
      before { board.name = '' }
      
      it { should_not be_valid }
    end

    context "when a duplicate is built" do
      let!(:board2) { create(:board, name: board.name) }
      
      it { should_not be_valid }
    end

    context "when too long" do
      before { board.name = 'a' * 101 }
    
      it { should_not be_valid }
    end
  end

end
