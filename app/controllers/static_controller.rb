class StaticController < PromotionalController

  tab :welcome
  
  def welcome
    
  end
  
  def terms
    render :layout => false
  end
end
