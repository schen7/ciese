require 'spec_helper'

describe Profile do
  let(:profile) { build(:profile) }

  subject { profile }

  it { should respond_to(:user) }
  it { should respond_to(:ciese_id) }
  it { should respond_to(:first_name) }
  it { should respond_to(:middle_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:prefix) }
  it { should respond_to(:title) }
  it { should respond_to(:greeting) }
  it { should respond_to(:ssn) }
  it { should respond_to(:email1) }
  it { should respond_to(:email2) }
  it { should respond_to(:department) }
  it { should respond_to(:subject) }
  it { should respond_to(:grade) }
  it { should respond_to(:function) }
  it { should respond_to(:district) }
  it { should respond_to(:affiliation) }
  it { should respond_to(:address_line_1) }
  it { should respond_to(:address_line_2) }
  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:zip) }
  it { should respond_to(:country) }
  it { should respond_to(:phone1) }
  it { should respond_to(:phone2) }
  it { should respond_to(:fax) }
  it { should respond_to(:home_address_line_1) }
  it { should respond_to(:home_address_line_2) }
  it { should respond_to(:home_city) }
  it { should respond_to(:home_state) }
  it { should respond_to(:home_zip) }
  it { should respond_to(:home_phone) }
  it { should respond_to(:home_mobile) }
  it { should respond_to(:home_fax) }
  it { should respond_to(:memo1) }
  it { should respond_to(:memo2) }
  it { should respond_to(:memo3) }

  it { should be_valid }

end
