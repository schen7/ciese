module FormResponseHelper

  def render_html(text = "")
    text.gsub(/\n/, "<br>").gsub(/ /, "&nbsp;").html_safe
  end

end

