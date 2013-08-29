require 'spec_helper'

describe Activity do
  let(:activity) { build(:activity) }

  subject { activity }

  it { should respond_to(:profile) }
  it { should respond_to(:program) }
  it { should respond_to(:detail) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }

  it { should be_valid }

end
