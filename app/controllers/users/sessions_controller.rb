module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource, store: false)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end

    private

    # Devise's default #all_signed_out? uses +warden.user+, which only reads the session.
    # With JWT-only auth and +store: false+, no user is ever in the session, so sign-out
    # was always treated as "already signed out" (+401+). +warden.authenticate+ runs
    # strategies (including JWT from the +Authorization+ header).
    def all_signed_out?
      Devise.mappings.keys.all? do |scope|
        warden.authenticate(scope: scope).blank?
      end
    end
  end
end
