class WahaWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    payload = params[:payload] || {}
    message_text = payload[:body].to_s
    sender_number = extract_number(payload[:from])
    own_number = extract_number(params.dig(:me, :id))
    inbound_message = payload[:fromMe] != true && sender_number.present? && sender_number != own_number


    if inbound_message && message_text == "/skibidi"
      Waha::SendMessage.new(
        phone: sender_number,
        text: "Skibidi bop yes yes yes"
      ).call
    end

    if inbound_message && message_text == "/jcmgln"
      Waha::SendMessage.new(
        phone: sender_number,
        text: "Joder tio como me gusta la noche"
      ).call
    end

    head :ok
  end

  private

  def extract_number(value)
    raw_value = value.to_s
    return "" if raw_value.blank?

    return resolve_lid_number(raw_value) if raw_value.end_with?("@lid")

    raw_value.split("@").first
  end

  def resolve_lid_number(lid)
    result = Waha::ResolvePhoneByLid.call(lid: lid)
    result.phone_number.presence || lid.split("@").first
  end
end
