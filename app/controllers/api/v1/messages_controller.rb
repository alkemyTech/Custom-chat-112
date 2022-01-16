# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authorize_request
      before_action :set_conversation, only: %i[create]
      before_action :set_message, only: %i[create]

      def create
        if set_conversation
          @conversation.users << current_user
        else
          current_user.conversations.create!(state: '{"status": "active" }')
        end
        @message = @conversation.messages.build(message_params)
        @message.user = current_user
        if @message.save
          render json: MessageSerializer.new(@message), status: :created
        else
          render json: @message.errors, status: :unprocessable_entity
        end
      end

      private

      def message_params
        params.require(:message).permit(:detail, :modified)
      end

      def set_conversation
        @conversation = Conversation.find_by(id: params[:conversation_id])
      end

      def set_message
        @message = Message.find_by(id: params[:message_id])
      end
    end
  end
end
