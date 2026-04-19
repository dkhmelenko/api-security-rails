class UsersController < ApplicationController
  # GET /users
  def index
    users = User.all

    render json: users
  end

  # GET /users/1
  def show
    user = User.find(params[:id])
    render json: user
  end

  # POST /users
  def create
    user = User.new(params[:user])

    if user.save
      render json: user, status: :created, location: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    user = User.find(params[:id])
    if user.update(params[:user])
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    User.find(params[:id]).destroy!
  end
end
