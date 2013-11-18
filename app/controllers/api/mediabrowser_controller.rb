class Api::MediabrowserController < ApplicationController
  MEDIA_ROOT = Rails.root.join('public/media')

  before_action :api_require_login
  before_action :api_require_staff_or_admin

  rescue_from Errno::ENOENT, with: :bad_path
  rescue_from Errno::ENOTDIR, with: :not_directory

  def index
    render json: get_file_list(params[:path] || "")
  end

  def upload
    render json: save_uploaded_file(upload_params)
  end

  private

  def get_file_list(path)
    full_path = MEDIA_ROOT.join(path)
    non_dot_files = Dir.new(full_path).reject { |file| file[0] == '.' }
    files = non_dot_files.map do |file|
      stat = File.stat(full_path.join(file))
      file_path = "/media/#{path}/#{file}".gsub("//", "/")
      {"name" => file, "path" => file_path, "size" => stat.size, "modified" => stat.mtime,
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

  def save_uploaded_file(info)
    File.open(MEDIA_ROOT.join(info['path'], info['file'].original_filename), 'wb') do |file|
      file.write(info['file'].read)
    end
    {"status" => "File successfully saved."}
  end

  def upload_params
    params.permit(:path, :file)
  end

end
