require 'spec_helper'

describe PublishedPage do
  let(:published_page) { build(:published_page) }

  subject { published_page }

  it { should respond_to(:version) }
  it { should respond_to(:page_id) }

  it { should be_valid }

end
