# frozen_string_literal: true

require "faraday"
require "json"
require "cgi"

module Waha
  class ResolvePhoneByLid
    Result = Struct.new(
      :success?,
      :phone_jid,
      :phone_number,
      :lid,
      :raw_response,
      :error_message,
      keyword_init: true
    )

    DEFAULT_SESSION = "default"
    DEFAULT_TIMEOUT = 15

    BASE_URL = ENV.fetch("WAHA_BASE_URL", "http://localhost:3000")
    API_KEY  = ENV.fetch("WAHA_API_KEY")

    def self.call(...)
      new(...).call
    end

    def initialize(lid:, session: DEFAULT_SESSION)
      @lid = lid.to_s.strip
      @session = session.to_s.presence || DEFAULT_SESSION
    end

    def call
      validate!

      response = connection.get(endpoint) do |req|
        req.headers["Accept"] = "application/json"
        req.headers["X-Api-Key"] = API_KEY
      end

      parsed = parse_json(response.body)

      if response.success?
        pn = parsed["pn"]

        Result.new(
          success?: pn.present?,
          phone_jid: pn,
          phone_number: extract_digits_from_pn(pn),
          lid: parsed["lid"] || normalized_lid,
          raw_response: parsed,
          error_message: pn.present? ? nil : "Phone number not found for LID"
        )
      else
        Result.new(
          success?: false,
          phone_jid: nil,
          phone_number: nil,
          lid: normalized_lid,
          raw_response: parsed,
          error_message: parsed["message"] || "WAHA error HTTP #{response.status}"
        )
      end
    rescue ArgumentError => e
      Result.new(
        success?: false,
        phone_jid: nil,
        phone_number: nil,
        lid: normalized_lid_or_nil,
        raw_response: nil,
        error_message: e.message
      )
    rescue Faraday::Error => e
      Result.new(
        success?: false,
        phone_jid: nil,
        phone_number: nil,
        lid: normalized_lid_or_nil,
        raw_response: nil,
        error_message: e.message
      )
    end

    private

    attr_reader :lid, :session

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |f|
        f.options.timeout = DEFAULT_TIMEOUT
        f.options.open_timeout = DEFAULT_TIMEOUT
        f.adapter Faraday.default_adapter
      end
    end

    def endpoint
      "/api/#{CGI.escape(session)}/lids/#{CGI.escape(lid_path_value)}"
    end

    def lid_path_value
      # WAHA acepta el LID completo o solo la parte numérica.
      normalized_lid
    end

    def normalized_lid
      value = lid.sub(/\A@/, "")
      value.end_with?("@lid") ? value : "#{value.gsub(/\D/, '')}@lid"
    end

    def normalized_lid_or_nil
      return nil if lid.blank?

      normalized_lid
    rescue StandardError
      nil
    end

    def extract_digits_from_pn(pn)
      return nil if pn.blank?

      pn.to_s.sub(/@c\.us\z/, "")
    end

    def validate!
      raise ArgumentError, "lid is required" if lid.blank?

      digits = lid.gsub(/\D/, "")
      raise ArgumentError, "lid is invalid" if digits.blank?
    end

    def parse_json(body)
      return {} if body.blank?

      JSON.parse(body)
    rescue JSON::ParserError
      { "raw_body" => body }
    end
  end
end