class UsersController <ApplicationController
  before_action :customer, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :now_user, only: [:edit, :update]

  def show
    @show_post_tab = params[:tab] != 'comments'
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Yor are register success."
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your profile was updated."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:username, :password, :time_zone)
    end

    def set_user
      @user = User.find_by(slug: params[:id])
    end

    def now_user
      unless current_user?(@user)
        flash[:error] = "You're not allowed to do that."
        redirect_to root_path
      end
    end
end