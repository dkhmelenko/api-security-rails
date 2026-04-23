module Users
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    protected

    def sign_up(resource_name, resource)
      sign_in(resource_name, resource, store: false)
    end

    private

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end

    def account_update_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name)
    end
  end
end
