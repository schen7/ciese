require 'spec_helper'

describe CurrentForm do
  let(:current_form) { build(:current_form) }

  subject { current_form }

  it { should respond_to(:form_version) }
  it { should respond_to(:form_id) }
  it { should respond_to(:slug) }

  it { should be_valid }

end
