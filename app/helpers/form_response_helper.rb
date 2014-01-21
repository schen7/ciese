module FormResponseHelper

  def render_html(text)
    text.gsub(/\n/, "<br>").gsub(/ /, "&nbsp;")
  end

end

