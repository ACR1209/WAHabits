# frozen_string_literal: true

require "faraday"
require "json"

module Waha
  class SendMessage
    Result = Struct.new(
      :success?,
      :message_id,
      :raw_response,
      :error_message,
      keyword_init: true
    )

    DEFAULT_SESSION = "default"
    DEFAULT_TIMEOUT = 15

    BASE_URL = ENV.fetch("WAHA_BASE_URL", "http://localhost:3000")
    API_KEY = ENV.fetch("WAHA_API_KEY", nil)
    ENDPOINT = "/api/sendText"

    def self.call(...)
      new(...).call
    end

    def initialize(phone:, text:, session: DEFAULT_SESSION)
      @phone = phone.to_s
      @text = text.to_s
      @session = session.to_s.presence || DEFAULT_SESSION
    end

    def call
      validate!

      response = connection.post(ENDPOINT) do |req|
        req.headers["Accept"] = "application/json"
        req.headers["Content-Type"] = "application/json"
        req.headers["X-Api-Key"] = API_KEY
        req.body = request_body.to_json
      end

      parsed = parse_json(response.body)

      if response.success?
        Result.new(
          success?: true,
          message_id: parsed["id"],
          raw_response: parsed,
          error_message: nil
        )
      else
        Result.new(
          success?: false,
          message_id: nil,
          raw_response: parsed,
          error_message: parsed["message"] || "WAHA error HTTP #{response.status}"
        )
      end
    rescue ArgumentError => e
      Result.new(
        success?: false,
        message_id: nil,
        raw_response: nil,
        error_message: e.message
      )
    rescue Faraday::Error => e
      Result.new(
        success?: false,
        message_id: nil,
        raw_response: nil,
        error_message: e.message
      )
    end

    private

    attr_reader :phone, :text, :session

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |f|
        f.options.timeout = DEFAULT_TIMEOUT
        f.options.open_timeout = DEFAULT_TIMEOUT
        f.adapter Faraday.default_adapter
      end
    end

    def request_body
      {
        session: session,
        chatId: normalized_chat_id,
        text: text
      }
    end

    def normalized_chat_id
      "#{normalized_phone}@c.us"
    end

    def normalized_phone
      digits = phone.gsub(/\D/, "")
      raise ArgumentError, "phone is required" if digits.blank?

      digits
    end

    def validate!
      raise ArgumentError, "text is required" if text.blank?
    end

    def parse_json(body)
      return {} if body.blank?

      JSON.parse(body)
    rescue JSON::ParserError
      { "raw_body" => body }
    end
  end
end