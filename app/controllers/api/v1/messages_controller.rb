# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authorize_request
      before_action :set_conversation, only: %i[index create]
      before_action :set_message, only: %i[show]
      after_action { pagy_headers_merge(@pagy) if @pagy }

      def index
        @pagy, @messages = pagy(
          @conversation.messages.all,
          items: params[:items] || 10,
          page: params[:page] || 1
        )
        @messages.each do |chat|
          chat.each do |message|
            if @user.settings.include? 'true'
              @message = message
              @message.detail = settings
            end
          end
        end
        @messages.order(created_at: :desc)
        render json: MessageSerializer.new(@messages).serializable_hash.to_json
      end

      def show
        if owner?
          render json: {
            'data': @message
          }, status: :ok
        else
          render json: MessageSerializer.new(@message).serializable_hash.to_json, status: :ok
        end
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
          @message.detail = settings if @user.settings.include? 'true'

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
      rescue ActiveRecord::RecordNotFound
        render json:
        {
          error: "Could not find conversation with ID '#{params[:id]}'"
        }, status: :not_found
      end

      def set_message
        @message = Message.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json:
        {
          error: "Could not find message with ID '#{params[:id]}'"
        }, status: :not_found
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

      def owner?
        @message.user == @current_user
      end
    end
  end
end
