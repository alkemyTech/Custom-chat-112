class Api::V1::UsersController < ApplicationController
  before_action :authorize_request
  before_action :set_user, only: %i[show]

  def index
    @users = User.All
    render json: UserSerializer.new(@users).serializable_hash.to_json
  end

  def show
    if admin?
      render json: @user      
    else
      render json: UserSerializer.new(@user).serializable_hash.to_json
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json:
      {
        error: "Could not find user with ID '#{params[:id]}'"
      }, status: :unprocessable_entity
  end
end