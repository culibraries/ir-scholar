class ApplicationController < ActionController::Base
  def default_url_options
    if Rails.env.production?
      {:host => "scholar.colorado.edu"}
    else  
      {}
    end
  end
  helper Openseadragon::OpenseadragonHelper
  helper Zizia::Engine.helpers
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  skip_after_action :discard_flash_if_xhr
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'


  protect_from_forgery with: :exception
end
