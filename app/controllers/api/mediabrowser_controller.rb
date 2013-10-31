class Api::MediabrowserController < ApplicationController
  MEDIA_ROOT = Rails.root.join('public/media')

  before_action :api_require_login
  before_action :api_require_staff_or_admin

  def index
    respond_to do |format|
      format.json do 
        render json: get_file_list(params[:path] || "")
      end
    end
  end

  private

  def get_file_list(path)
    full_path = MEDIA_ROOT.join(path)
    if !File.exists?(full_path)
      {"error" =>  "Path does not exist."}
    elsif !File.directory?(full_path)
      {"error" =>  "Path is not a directory."}
    else
      construct_file_list(path, full_path)
    end
  end

  def construct_file_list(relative_path, full_path)
    non_dot_files = Dir.new(full_path).reject { |file| file[0] == '.' }
    files = non_dot_files.map do |file|
      stat = File.stat(full_path.join(file))
      url = "/media/#{relative_path}/#{file}".gsub("//", "/")
      {"url" => url, "size" => stat.size, "modified" => stat.mtime}
    end
    {"files" => files}
  end

end
