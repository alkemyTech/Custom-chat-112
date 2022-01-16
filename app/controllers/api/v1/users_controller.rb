# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: :destroy

      def create
        @user = User.new(user_params)
        @user.is_admin = false

        if @user.save
          render json: @user, status: :created
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
        params.permit(:name, :password, :email, :id)
      end
    end
  end
end
