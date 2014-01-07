require 'spec_helper'

describe Admin::PagesController do

  describe "GET #index" do
    let(:method) { :get }
    let(:action) { :index }
    let(:params) { }

    it_behaves_like "an action that requires an active staff or admin user"
  end

  describe "GET #versions" do
    let(:method) { :get }
    let(:action) { :versions }
    let(:params) { {page_id: 1} }

    it_behaves_like "an action that requires an active staff or admin user"
  end

  describe "GET #show_version" do
    let(:method) { :get }
    let(:action) { :show_version }
    let(:params) { {page_id: 1, id: 1} }

    it_behaves_like "an action that requires an active staff or admin user"
  end

  describe "GET #new" do
    let(:method) { :get }
    let(:action) { :new }
    let(:params) { }

    it_behaves_like "an action that requires an active staff or admin user"
  end

  describe "GET #edit" do
    let(:method) { :get }
    let(:action) { :edit }
    let(:params) { {page_id: 1, vid: 1} }

    it_behaves_like "an action that requires an active staff or admin user"
  end
end

