require 'spec_helper'

describe PublishedForm do
  let(:published_form) { build(:published_form) }

  subject { published_form }

  it { should respond_to(:form_version) }
  it { should respond_to(:form_id) }
  it { should respond_to(:slug) }

  it { should be_valid }

end

