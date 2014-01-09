require 'spec_helper'

describe Api::MediabrowserController do

  describe "GET #index" do
    let(:method) { :get }
    let(:action) { :index }
    let(:params) { {} }

    it_behaves_like "an api action that requires an active staff or admin user"

    context "when accessed by an authorized user" do
      before(:all) do
        @media_root = Api::MediabrowserController::MEDIA_ROOT
        @bad_path = @media_root.join('nog00d')
        @test_dir = @media_root.join('XXX_test_dir_101')
        @test_file = @media_root.join(@test_dir, 'XXX_test_file_101.txt')
        Dir.mkdir(@test_dir) if !Dir.exists?(@test_dir)
        File.new(@test_file, 'w+').close
      end
      after(:all) do
        File.unlink(@test_file)
        Dir.rmdir(@test_dir)
      end

      let(:staff) { create(:staff) }
      before { controller.log_in(staff) }

      context "when the path is invalid" do
        before { get :index, format: :json, path: File.basename(@bad_path) }

        it "should result in a 400 error with an appropriate json message" do
          expect(response.code).to eq "400"
          data = ActiveSupport::JSON.decode(response.body)
          expect(data).to eq({"error" => "Path does not exist."})
        end
      end

      context "when the path is not a directory" do
        before do
          relpath = "#{File.dirname(@test_file)}/#{File.basename(@test_file)}"
          get :index, format: :json, path: relpath
        end

        it "should result in a 400 error with an appropriate json message" do
          expect(response.code).to eq "400"
          data = ActiveSupport::JSON.decode(response.body)
          expect(data).to eq({"error" => "Path is not a directory."})
        end
      end

      context "when the path is a valid directory" do
        before { get :index, format: :json, path: File.basename(@test_dir) }

        it "should render a json list of files in the path" do
          expect(response.code).to eq "200"
          data = ActiveSupport::JSON.decode(response.body)
          url = "/media/#{File.basename(@test_dir)}/#{File.basename(@test_file)}"
          expect(data["files"][0]["url"]).to eq url
          expect(data["files"][0]["size"]).to eq 0
          expect(data["files"][0]["type"]).to eq "file"
        end
      end
    end
  end

end


