# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authorize_request
      before_action :set_chat
      after_action { pagy_headers_merge(@pagy) if @pagy }

      def index
        @pagy, @messages = pagy(
          @chat.messages.all,
          items: params[:items] || 10,
          page: params[:page] || 1
        )
        @messages.order(created_at: :desc)
        render json: MessageSerializer.new(@messages).serializable_hash.to_json
      end

      private

      def set_chat
        @chat = Chat.find(params[:chat_id])
      end

      message = "Vete a la mierda"

def word_comparer(string)
  new_word = []
  split_word = string.split
  split_word.each do |word|
    revised_word = bad_word_detector(word)
    new_word << revised_word
    new_word_join = new_word.join(' ')
  end
  new_string(new_word)
end

def new_string(array)
  revised_string = array.join(' ')
  puts revised_string
end

def bad_word_detector(word)
  bad_words = ["tonto", "cagón", "mierda", "puta"]
  if bad_words.include?(word)
    bad_word = bad_words.select { |bad_word| bad_word == word }
    bad_word_split = bad_word[0].to_s.split(//)
    censored_word = bad_word_split.map { |x| '*'}
    censored_word_join = censored_word.join
  else
     no_bad_word = word
  end
end

    end
  end
end
