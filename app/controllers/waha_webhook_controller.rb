class WahaWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    payload = params[:payload] || {}
    message_text = payload[:body].to_s
    sender_number = extract_number(payload[:from])
    recipient_number = extract_number(payload[:to])
    own_number = extract_number(params.dig(:me, :id))
    inbound_message = payload[:fromMe] != true && sender_number.present? && sender_number != own_number

    logger.info "Received webhook: #{params.to_unsafe_h}"
    logger.info "Texto enviado: #{message_text}"
    logger.info "Numero emisor: #{sender_number}"
    logger.info "Numero receptor: #{recipient_number}"

    if inbound_message && message_text == "/skibidi"
      Waha::SendMessage.new(
        phone: sender_number,
        text: "Skibidi bop yes yes yes"
      ).call
    end

    head :ok
  end

  private

  def extract_number(value)
    value.to_s.split("@").first
  end
end
