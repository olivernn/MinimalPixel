class ProjectWorker < Workling::Base
  def publish_to_facebook(options)
    @project = Project.find(options[:project_id])
    @fb_user = @project.user.facebook_user_details
    if @project.user.facebook_user?
      options[:fb_session].user.publish_to(options[:fb_session].user, 
                                           :message => "I've just published a new project on MinimalPixel.net, take a look.",
                                           :action_links => [:text => @project.name, :href => options[:url]],
                                           :attachment => [
                                             :name => @project.items.first.name,
                                             :href => options[:url],
                                             :description => @project.description,
                                             :media => [
                                               :type => @project.items.first.type.to_s.downcase,
                                               :src => "http://localhost:3000/" + @project.items.first.source.url,
                                               :href => options[:url]
                                              ]
                                            ])
    end
  end
end