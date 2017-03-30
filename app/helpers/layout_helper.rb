# encoding: UTF-8

# Helper regarding to layout. Any method needed in the application layout.
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title, page_title.to_s)
    @show_title = show_title
  end

  def show_title?
    @show_title || false
  end
end
