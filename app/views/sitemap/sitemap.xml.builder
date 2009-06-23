xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  
  unless @users.empty?
    @users.each do |user|
      xml.url do
        xml.loc projects_root_url(:subdomain => user.subdomain)
      end
      
      user.projects.active.each do |project|
        xml.url do
          xml.loc project_url(project, :subdomain => user.subdomain)
          xml.lastmod project.updated_at.to_date
        end
        
        project.items.ready.each do |item|
          xml.url do
            xml.loc project_item_url(project, item, :subdomain => user.subdomain)
            xml.lastmod item.updated_at.to_date
          end
        end
      end
      
      user.pages.each do |page|
        xml.url do
          xml.loc page_url(page, :subdomain => user.subdomain)
          xml.lastmod page.updated_at.to_date
        end
      end
    end
  end
  
  @articles.each do |article|
    xml.url do
      xml.loc article_url(article, :subdomain => 'blog')
      xml.lastmod article.created_at.to_date
    end
  end
  
  xml.url do
    xml.loc root_url
  end
end