class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authorize_self!, only: %i[show update destroy]

  # GET /users
  def index
    users = User.all

    render json: users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_self!
    return if @user == current_user

    head :forbidden
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
