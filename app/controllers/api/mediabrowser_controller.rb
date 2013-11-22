class Api::MediabrowserController < ApplicationController
  PUBLIC_ROOT = Rails.root.join('public')
  MEDIA_ROOT = PUBLIC_ROOT.join('media')
  THUMBNAIL_ROOT = PUBLIC_ROOT.join('thumbs')
  IMG_EXTS = [".jpg", ".jpeg", ".png", ".gif"]

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
    abs_path = MEDIA_ROOT.join(path)
    non_dot_files = Dir.new(abs_path).reject { |filename| filename[0] == '.' }
    {"files" => non_dot_files.map { |filename| get_file_data(abs_path.join(filename)) }}
  end

  def get_file_data(abs_file_path)
    stat = abs_file_path.stat
    file_url = abs_file_path.sub(PUBLIC_ROOT.to_s, '')
    file_data = {
      "name" => abs_file_path.basename.to_s, "url" => file_url.to_s, "size" => stat.size,
      "modified" => stat.mtime, "type" => stat.directory? ? "directory" : "file"
    }
    file_data
    if IMG_EXTS.include?(abs_file_path.extname.downcase)
      file_data.merge(get_thumbnail_data(abs_file_path))
    else
      file_data
    end
  end

  def bad_path
    render json: {"error" =>  "Path does not exist."}, status: 400
  end

  def not_directory
    render json: {"error" =>  "Path is not a directory."}, status: 400
  end

  def get_thumbnail_data(abs_file_path)
    thumb_path = abs_file_path.sub(MEDIA_ROOT.to_s, THUMBNAIL_ROOT.to_s)
    if thumb_path.exist?
      {"image" => true, "thumb_url" => thumb_path.sub(PUBLIC_ROOT.to_s, '').to_s}
    else
      {}
    end
  end

  def save_uploaded_file(info)
    file = File.new(MEDIA_ROOT.join(info['path'], info['file'].original_filename), 'wb')
    file.write(info['file'].read)
    file.close()
    file_path = Pathname.new(file.path)
    create_thumbnail(file_path, 100, 100) if IMG_EXTS.include?(file_path.extname.downcase)
    get_file_data(file_path)
  end

  def upload_params
    params.permit(:path, :file)
  end

  def create_thumbnail(file_path, w, h)
    image = MiniMagick::Image.open(file_path)
    thumb_path = file_path.sub(MEDIA_ROOT.to_s, THUMBNAIL_ROOT.to_s)
    thumb_dir = thumb_path.dirname
    thumb_dir.mkdir unless thumb_dir.exist?
    image.resize("#{w}x#{h}")
    image.write(thumb_path)
  end
end
