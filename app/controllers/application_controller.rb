class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale, :set_root_url

  inertia_share flash: -> {
    {
      success: flash[:success],
      error: flash[:error]
    }
  }
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_root_url
    @root_url = "#{request.base_url}/#{I18n.locale}"
  end
end
