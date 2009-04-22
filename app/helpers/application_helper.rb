module ApplicationHelper
  
  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
  
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end
  
  def user_stylesheet
    if current_subdomain
      stylesheet_link_tag styles_path(:format => :css, :subdomain => current_subdomain_user.subdomain), :id => "user_styles"
    end
  end
  
  def user_font
    if current_subdomain
      javascript_include_tag styles_path(:format => :js, :subdomain => current_subdomain_user.subdomain), :id => "user_font"
    end
  end
  
  def border_styles(style)
    case style.border_type
    when "thin": "border:1px solid #{style.theme.border_colour};"
    when "polaroid": "border:8px solid #{style.theme.border_colour}; border-bottom:24px solid #{style.theme.border_colour};"
    when "fat": "border:8px solid #{style.theme.border_colour};"
    end
  end
  
  def header_border(style)
    case style.border_type
    when "thin" : "border-bottom: 2px solid #{style.theme.border_colour};"
    else "border-bottom: 5px solid #{style.theme.border_colour};"
    end
  end
  
  def sidebar_border(style)
    case style.border_type
    when "thin" : "border-left-style:solid; border-left-width: 2px; border-left-color: #{style.theme.border_colour};"
    else "border-left-style:solid; border-left-width: 5px; border-left-color: #{style.theme.border_colour};"
    end
  end
  
  # methods that set the meta tags for the page
  #displays a nice page title easily
  def meta_title(text)
    content_for(:title) { text }
  end
  
  #allows us to specify the keywords for a page
  def meta_keywords(keywords)
    content_for(:keywords) { keywords }
  end
  
  #allows us to specify the description for a page
  def meta_description(description)
    content_for(:description) { description }
  end
  
  def render_item(item, project)
    if item.class.to_s == "Image"
      render :partial => 'images/image', :locals => {:image => item, :project => project}
    else
      # it must be a video
      render :partial => 'videos/video', :locals => {:video => item, :project => project}
    end
  end
  
  def display_populated_attributes(profile)
    html = String.new
    ['location', 'phone', 'freelance', 'skills', 'web'].each do |field|
      if profile.attributes[field]
        html << "<li><strong>#{field.humanize}:</strong> #{profile.attributes[field]}</li>" unless profile.attributes[field].empty?
      end
    end
    html
  end
end
