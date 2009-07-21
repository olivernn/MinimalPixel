class ProcessorWorker < Workling::Base
  def image_processor(options)
    @image = Image.find(options[:image_id])
    @image.start_processing!
    if @image.source.reprocess!
      @image.end_processing!
      clear_cache(@image)
    else
      @image.error!
    end
  end
  
  def video_processor(options)
    @video = Video.find(options[:video_id])
    if @video.start_processing!
      @video.end_processing!
      clear_cache(@video)
    else
      @video.error!
    end
  end
  
  private
  
  # this violates MVC a little bit but we need to expire the cached item show page which currently has the "processing"
  # message displayed.  It will also expire the project show page incase the user navigates back to it and triggers the
  # caching without the newly processed item.
  def clear_cache(item)
    ActionController::Base.new.expire_fragment(%r{#{item.project.user.subdomain}/items/show/#{item.to_param}*})
    ActionController::Base.new.expire_fragment(%r{#{item.project.user.subdomain}/projects/show/#{item.project.to_param}*})
  end
end