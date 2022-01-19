# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize_request, except: :create
      before_action :set_user, only: %i[update destroy]

      def index
        @users = User.all
        render json: UserSerializer.new(@users).serializable_hash.to_json
      end

      def create
        @user = User.new(user_params)

        if @user.save
          token = AuthTokenService.call(@user.id)
          render json: {
            'token' => token,
            'user' => UserSerializer.new(@user).serializable_hash
          }
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @user.destroy
          head :no_content
        else
          render :json, @user.errors, status: 422
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

      def user_params
        params.require(:user).permit(:name, :password, :email)
      end
    end
  end
end
