class Api::MediabrowserController < ApplicationController
  MEDIA_ROOT = Rails.root.join('public/media')

  before_action :api_require_login
  before_action :api_require_staff_or_admin

  rescue_from Errno::ENOENT, with: :bad_path
  rescue_from Errno::ENOTDIR, with: :not_directory

  def index
    respond_to do |format|
      format.json { render json: get_file_list(params[:path] || "") }
    end
  end

  private

  def get_file_list(path)
    full_path = MEDIA_ROOT.join(path)
    non_dot_files = Dir.new(full_path).reject { |file| file[0] == '.' }
    files = non_dot_files.map do |file|
      stat = File.stat(full_path.join(file))
      url = "/media/#{path}/#{file}".gsub("//", "/")
      {"name" => file, "url" => url, "size" => stat.size, "modified" => stat.mtime,
       "type" => stat.directory? ? "directory" : "file"}
    end
    {"files" => files}
  end

  def bad_path
    render json: {"error" =>  "Path does not exist."}, status: 400
  end

  def not_directory
    render json: {"error" =>  "Path is not a directory."}, status: 400
  end

end
