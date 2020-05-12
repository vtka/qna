class ConfirmationsController < Devise::ConfirmationsController
  def create
    @email = confirmation_params[:email]
    find_or_create_user

    return @user.send_confirmation_instructions if @user.persisted?

    if @user.save
      flash[:notice] = "Confirmation instructions sent to #{@user.email}"
      redirect_to root_path
    else
      flash.now[:alert] = 'Invalid email'
      render :new
    end
  end

  protected

  def find_or_create_user
    @user = User.find_by_email(@email)

    password = Devise.friendly_token[0, 20]
    @user ||= User.new(email: @email, password: password, password_confirmation: password)
    @user
  end

  def after_confirmation_path_for(_resource_name, user)
    if session[:provider].present? && session[:uid].present?
      user.identities.create(provider: session["devise.provider"], uid: session["devise.uid"])
    end

    sign_in user, event: :authentication
    root_path
  end

  def confirmation_params
    params.require(:user).permit(:email)
  end
end