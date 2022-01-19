# frozen_string_literal: true

module Api
  module V1
    class ConversationsController < ApplicationController

      def create
        @conversation = Conversation.new(conversation_params)
        @message = @conversation.messages.new(message_params)
        @message.user_id = params[:user1_id]

        if @conversation.save && @message.save
          render json: @conversation
        else
          render json: { convo: @conversation.errors },
                 status: :unprocessable_entity
        end
      end

      private

      def conversation_params
        params.permit(:user1_id, :user2_id, :state)
      end

      def message_params
        params.permit(:detail)
      end
    end
  end
end
