class ApplicationController < ActionController::Base
  protect_from_forgery
  include Wiki::Controllers::ActionResult
  include Wiki::Controllers::Sidebar::CommonSidebar

  protected

  def model_params
    self.params[self.controller_model_type] || {}
  end  

  def controller_model_type
    self.controller_name.singularize.to_s
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
