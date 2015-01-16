class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :flash_to_headers

  helper_method :current_user, :current_user?, :logged_in?, :admin?, :sort_voteable

  def customer
    if logged_in?
      flash[:error] = 'You also login!'
      redirect_to root_path
    end
  end

  def login_user
    unless logged_in?
      flash[:error] = 'You must login first!'
      redirect_to root_path
    end
  end

  def admin_role
    unless admin?
      flash[:error]  = "You can't do it"
      redirect_to :back
    end
  end

  #
  # Helper method
  #
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    current_user.id == user.id
  end

  def logged_in?
    !!current_user
  end

  def admin?
    logged_in? && current_user.admin?
  end

  def sort_voteable(elements)
    elements.sort_by { |e| e.total_votes }.reverse
  end

  private

    def flash_to_headers
      return unless request.xhr?
      response.headers['X-Message'] = flash_message
      response.headers['X-Message-Type'] = flash_type.to_s

      flash.discard # don't want the flash to appear when you reload page
    end

    def flash_message
      [:error, :warning, :notice].each do |type|
        return flash[type] unless flash[type].blank?
      end

      # if we don't return something here, the above code will return "error, warning, notice"
      return ''
    end

    def flash_type
      # :keep will instruct the js to not update or remove the shown message.
      # just write flash[:keep] = true (or any other value) in your controller code
      [:error, :warning, :notice, :keep].each do |type|
        return type unless flash[type].blank?
      end

      # if we don't have an explicit return statement, the above code will return "error, warning, notice, keep"
      # :empty will also allow you to easily know that no flash message was transmitted
      return :empty
    end

end
