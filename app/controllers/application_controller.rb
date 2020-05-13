class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  def gon_user
    gon.user_id = current_user.id if current_user
  end

  def self.renderer_with_user(user)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i|
      i.set_user(user, scope: :user, store: false, run_callbacks: false)
    }
    renderer.new('warden' => proxy)
  end

  rescue_from CanCan::AccessDenied do |exception|
    if request.format == :html
      redirect_to root_url, alert: exception.message
    else
      render(file: Rails.root.join('public', '403'), formats: [:html], status: 403, layout: false)
    end
  end

  check_authorization unless :devise_controller?
end
