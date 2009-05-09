class ProcessorWorker < Workling::Base
  def image_processor(options)
    @image = Image.find(options[:image_id])
    @image.start_processing!
    if @image.source.reprocess!
      @image.end_processing!
    else
      @image.error!
    end
  end
  
  def video_processor(options)
    @video = Video.find(options[:video_id])
    if @video.start_processing!
      @video.end_processing!
    else
      @video.error!
    end
  end
end