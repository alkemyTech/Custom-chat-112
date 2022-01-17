# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authorize_request
      before_action :set_conversation, only: %i[create]

      def create
        @message = @conversation.messages.new(message_params)
        @message.user = current_user
        if @message.save
          render json: conversation_messages_url(@conversation), status: :created
        else
          render json: @message.errors, status: :unprocessable_entity
        end
      end

      private

      def message_params
        params.require(:message).permit(:user_id, :detail, :modified)
      end

      def set_conversation
        @conversation = Conversation.find(params[:conversation_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Couldn´t find a conversation with ID '#{params[:conversation_id]}'" }
      end
    end
  end
end
