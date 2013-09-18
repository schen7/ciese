module AngularHelper
  def include_templates(app_name, templates_path)
    coffee = <<-EOF.strip_heredoc
      angular
        .module('#{app_name}')
        .run(["$templateCache", ($templateCache) ->
    EOF

    templates_abs_path = Rails.root.join(templates_path)
    Dir.new(templates_abs_path).each do |fname|
      if !File.directory?(fname)
        File.open(templates_abs_path.join(fname), mode='r') do |file|
          coffee << "    $templateCache.put('#{fname}', \"\"\"#{file.read}\"\"\")\n"
        end
      end
    end
    coffee << "  ])\n"
  end
end
