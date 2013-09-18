require 'spec_helper'

describe Program do
  let(:program) { build(:program) }

  subject { program }

  it { should respond_to(:name) }
  it { should respond_to(:details) }

  it { should be_valid }

  describe "#details" do
    before { program.save }

    specify { expect(program.reload.details.class).to be Array }
  end
end
