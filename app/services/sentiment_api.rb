# frozen_string_literal: true

class SentimentApi
  API_URL = 'https://sentim-api.herokuapp.com/api/v1/'
  HEADERS = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  }.freeze

  def self.get_from(text)
    return { "error": 'Cannot process this message.' } if text.blank?

    begin
      response = RestClient.post API_URL, { "text": text.to_s }.to_json, HEADERS
      return { "error": 'Cannot connect to Sentiment API.' } unless response.code == 200
    rescue StandardError
      return { "error": 'Cannot connect to Sentiment API.' }
    end

    JSON.parse(response.body)['result']
  end
end
