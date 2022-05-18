# frozen_string_literal: true

# Checks the authorization against the census for Getxo.
require "digest/md5"

# This class performs a check against the official census database in order
# to verify the citizen's residence.
class CensusAuthorizationHandler < Decidim::AuthorizationHandler
  include ActionView::Helpers::SanitizeHelper
  include Virtus::Multiparams

  # NIA=xxxxxx&lletraClau=X&dataNaixement=11/22/3333
  attribute :document_number, String
  attribute :date_of_birth, Date

  validates :date_of_birth, presence: true
  validates :document_number, format: { with: /(^[a-zA-Z]*)(\d+)([a-zA-Z]*$)/ }, presence: true

  validate :valid_data

  # If you need to store any of the defined attributes in the authorization you
  # can do it here.
  #
  # You must return a Hash that will be serialized to the authorization when
  # it's created, and available though authorization.metadata
  def metadata
    {
      date_of_birth: date_of_birth&.strftime("%Y-%m-%d"),
      zone: response["missatgeRetorn"]
    }
  end

  def unique_id
    Digest::MD5.hexdigest(
      "#{document_number&.upcase}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  private

  def sanitized_date_of_birth
    @sanitized_date_of_birth ||= date_of_birth&.strftime("%d/%m/%Y")
  end

  def extract_parts
    @extract_parts ||= /(^[a-zA-Z]*)(\d+)([a-zA-Z]*$)/.match document_number
  end

  def sanitized_document_number
    extract_parts[2].to_s if extract_parts
  end

  def sanitized_document_letter
    extract_parts[3].upcase if extract_parts
  end

  def valid_data
    errors.add(:base, I18n.t("census_authorization_handler.connection_error", scope: "decidim.authorization_handlers")) if response.nil?

    return if @code == "OK"

    case @message
    when /data de naixement/
      errors.add(:date_of_birth, I18n.t("census_authorization_handler.invalid_date_of_birth", scope: "decidim.authorization_handlers"))
    when /document/
      errors.add(:document_number, I18n.t("census_authorization_handler.invalid_document", scope: "decidim.authorization_handlers"))
    end
  end

  def response
    return @response if @response

    return nil if document_number.blank? ||
                  date_of_birth.blank?

    service = AndorraWebservice.new(
      document_number: sanitized_document_number,
      document_letter: sanitized_document_letter,
      date_of_birth: sanitized_date_of_birth
    )
    begin
      @response = service.response.body
      @code = @response["codiRetorn"]
      @message = @response["missatgeRetorn"]
    rescue StandardError
      nil
    end
  end
end
