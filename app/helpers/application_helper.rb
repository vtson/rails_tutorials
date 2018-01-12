module ApplicationHelper
  def full_title page_title = ""
    @page_title = page_title
    @base_title = t "layouttitle"
    @page_title.empty? ? @base_title : @page_title + " | " + @base_title
  end
end
