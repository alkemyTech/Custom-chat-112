# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authorize_request
      before_action :set_conversation, only: %i[index create]

      def index
        @pagy, @messages = pagy(
          @conversation.messages.all,
          items: params[:items] || 10,
          page: params[:page] || 1
        )
        @messages.each do |message|
          if @current_user.settings.include? 'true'
            @message = message
            @message.detail = settings
          end
        end
        @messages.order(created_at: :desc)
        render json: MessageSerializer.new(@messages).serializable_hash.to_json
      end

      def create
        unless set_conversation
          @conversation = Conversation.create!(state: '{ "status": "active" }')
        end

        if max_users?
          render json: { "error": 'Maximum conversation users limit reached' }
        else
          @conversation.users << @current_user
          @message = @conversation.messages.build(message_params)
          @message.user = @current_user
          @message.detail = settings if @current_user.settings.include? 'true'

          if @message.save
            render json: MessageSerializer.new(@message), status: :created
          else
            render json: @message.errors, status: :unprocessable_entity
          end
        end
      end

      private

      def set_conversation
        @conversation = @current_user.conversations.find_by(id: params[:conversation_id])
      end

      def max_users?
        Conversation.where(id: params[:conversation_id]).count == 2
      end

      def settings
        settings = eval(@current_user.settings)
        if settings['upcase'] == true
          @message.detail = @message.detail.upcase
        elsif settings['downcase'] == true
          @message.detail = @message.detail.downcase
        elsif settings['normalize'] == true
          @message.detail = ActiveSupport::Inflector.transliterate(@message.detail)
        end
      end

      def message_params
        params.require(:message).permit(:detail, :modified)
      end
    end
  end
end
