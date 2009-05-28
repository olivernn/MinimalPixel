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
  
  def sidebar_border(style, side)
    case style.border_type
    when "thin" : "border-#{side}-style:solid; border-#{side}-width: 2px; border-#{side}-color: #{style.theme.border_colour};"
    else "border-#{side}-style:solid; border-#{side}-width: 5px; border-#{side}-color: #{style.theme.border_colour};"
    end
  end
  
  def transaprent_background(style)
    "url(images/#{style.theme.name.downcase}_transparent.png)"    
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
      render :partial => 'videos/video', :locals => {:video => item, :project => project}
    end
  end
  
  def ready_image(image)
    logger.debug(image.status)
    if image.ready?
      link_to image_tag(image.source.url(:normal), :class => 'image', :alt => image.name), image.source.url(:large), :class => 'lightbox', :title => image.description
    else
      render :partial => 'items/not_ready', :locals => {:project => image.project, :item => image}
    end
  end
  
  def ready_video(video)
    if video.ready?
      # link_to video.name, video.source.url, :class => 'video_player'
      flv_player :file => video.source.url, :autostart => true, :showicons => false, :showdigits => false
    else
      render :partial => 'items/not_ready', :locals => {:project => video.project, :item => video}
    end
  end
  
  def display_profile_picture(profile, user)
    if profile.photo.exists?
      image_tag(profile.photo.url(:sidebar), :class => 'image', :alt => user.name)
    else
      image_tag 'pig.png', :class => 'image', :alt => user.name
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
  
  def display_plan_price(plan)
    if plan.free?
      "<em>Free!</em>"
    else
      "#{number_to_currency(plan.price)} per #{plan.payment_frequency}"
    end
  end
end
