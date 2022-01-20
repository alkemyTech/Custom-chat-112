# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      # before_action :authorize_request
      before_action :set_conversation, only: %i[index create]
      before_action :set_message, only: %i[show update destroy]
      # after_action { pagy_headers_merge(@pagy) if @pagy }

      # http://localhost:3000/api/v1/conversations/8/messages
      def index
        # @pagy, @messages = pagy(
        #   @conversation.messages.all,
        #   items: params[:items] || 10,
        #   page: params[:page] || 1
        # )
        # @messages.order(created_at: :desc)
        @messages = @conversation.messages
        render json: MessageSerializer.new(@messages).serializable_hash.to_json
      end

      # def create
      #   if set_conversation
      #     @conversation.users << current_user
      #   else
      #     current_user.conversations.create!(state: '{ "status": "active" }')
      #   end

      #   @message = @conversation.messages.build(message_params)
      #   @message.user = current_user

      #   if @message.save
      #     render json: MessageSerializer.new(@message), status: :created
      #   else
      #     render json: @message.errors, status: :unprocessable_entity
      #   end
      # end

      # http://localhost:3000/api/v1/messages/10
      def show
        if @message && owner?
          render json: MessageSerializer.new(@message).serializable_hash.to_json, status: :ok
        else
          render json: { "error": "message not available"}, status: :unprocessable_entity
        end
      end

      # http://localhost:3000/api/v1/conversations/8/messages?message[detail]=this is a test message
      def create
        if set_conversation
          # Si la conversación ha sido creada anteriormente solo se agrega el usuario
          @conversation.users << User.last # se debe cambiar por 'current_user'
        else
          # Si la conversación no existe se va a crear
          @conversation = User.last.conversations.create!(state: '{ "status": "active" }')
          # se debe cambiar User.last por current_user!
        end

        # Se podría agregar una lógica para verificar que la conversación tenga al menos dos
        # usuarios, pero es opcional
        @message = @conversation.messages.build(message_params)
        @message.user = User.last # se debe cambiar por current user

        if @message.save
          render json: MessageSerializer.new(@message), status: :created
        else
          render json: @message.errors, status: :unprocessable_entity
        end
      end

      # http://localhost:3000/api/v1/messages/10
      def update
        if @message && owner?
          @message.update(message_params)
          render json: MessageSerializer.new(@message), status: :ok
        else
          render json: { "error": 'message not available' }, status: :unprocessable_entity
        end
      end

      # http://localhost:3000/api/v1/messages/10
      def destroy
        # @message = current_user.messages.find_by(id: params[:id])
        if @message && owner?
          @message.destroy

          head :no_content
        else
          render json: { "error": 'message not available' }, status: :unprocessable_entity
        end
      end

      private

      def set_conversation
        @conversation = Conversation.find_by(id: params[:conversation_id])
      end

      def set_message
        @message = Message.find_by(id: params[:id])
      end

      def owner?
        # TODO crear lógica para verificar si es el propietario del mensaje
      end

      def message_params
        params.require(:message).permit(:detail, :modified)
      end
    end
  end
end
