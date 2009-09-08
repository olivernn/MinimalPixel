class ProjectWorker < Workling::Base
  def publish_to_facebook(options)
    @project = Project.find(options[:project_id])
    @fb_user = @project.user.facebook_user_details
    if @project.user.facebook_user?
      options[:fb_session].user.publish_to(options[:fb_session].user, 
                                           :message => "has just published a new project on MinimalPixel.net, take a look.",
                                           :action_links => [:text => @project.name, :href => options[:url]],
                                           :attachment => 
                                            {:media => [{:type => @project.items.first.class.to_s.downcase, :src => "http://minimalpixel.net" + @project.items.first.source.url, :href => options[:url]}]
                                            }
                                           )
    end
  end
  
  def destroy(options)
    Project.find(options[:project_id]).destroy
  end
end