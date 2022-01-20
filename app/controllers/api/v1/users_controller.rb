# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[update destroy config]

      def index
        @users = User.all
        render json: UserSerializer.new(@users).serializable_hash.to_json
      end

      def create
        @user = User.new(user_params)
        @user.is_admin = false

        if @user.save
          render json: @user, status: :created
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

      # http://localhost:3000/api/v1/users/5/config?user[config]={ "upcase": "true", "downcase": "false" }
      def config
        # @user.config = '{ "upcase": "true", "downcase": "false" }'
        @user.config = params[:config]
        if @user.save
          render json: { "status": 'configuration added successfully' }
        else
          render json: { "status": 'Error at configuration' }
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
        params.require(:user).permit(:name, :password, :email, :config)
      end
    end
  end
end
