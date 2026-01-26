# frozen_string_literal: true

require "digest/md5"

module Decidim
  module Elections
    module Censuses
      # Voter authentication form for the Andorra census election type.
      # Validates the voter's document number and date of birth against
      # the Andorra government census API.
      class AndorraCensusForm < Decidim::Form
        DOCUMENT_FORMAT = /(^[a-zA-Z]*)(\d+)([a-zA-Z]*$)/

        attribute :document_number, String
        attribute :date_of_birth, Decidim::Attributes::LocalizedDate

        validates :document_number, presence: true, format: { with: DOCUMENT_FORMAT }
        validates :date_of_birth, presence: true

        validate :census_data_valid

        def voter_uid
          return if document_number.blank?

          Digest::MD5.hexdigest("#{document_number.upcase}-#{Rails.application.secret_key_base}")
        end

        def election
          context&.election
        end

        private

        def census_data_valid
          return if errors.any?

          if response.nil?
            errors.add(:base, I18n.t("decidim.elections.censuses.andorra_census_form.connection_error"))
            return
          end

          return if code == "OK"

          case message
          when /data de naixement/
            errors.add(:date_of_birth, I18n.t("decidim.elections.censuses.andorra_census_form.invalid_date_of_birth"))
          else
            errors.add(:document_number, I18n.t("decidim.elections.censuses.andorra_census_form.invalid_document"))
          end
        end

        def response
          return @response if defined?(@response)

          return nil if document_number.blank? || date_of_birth.blank?

          begin
            @response = service.response.body
            @code = @response && @response["codiRetorn"]
            @message = @response && @response["missatgeRetorn"]
            @response
          rescue StandardError
            @response = nil
          end
        end

        attr_reader :code, :message

        def extract_parts
          @extract_parts ||= DOCUMENT_FORMAT.match(document_number)
        end

        def sanitized_document_number
          extract_parts[2].to_s if extract_parts
        end

        def sanitized_document_letter
          extract_parts[3].upcase if extract_parts
        end

        def sanitized_date_of_birth
          @sanitized_date_of_birth ||= date_of_birth&.strftime("%d/%m/%Y")
        end

        def service
          @service ||= AndorraWebservice.new(
            document_number: sanitized_document_number,
            document_letter: sanitized_document_letter,
            date_of_birth: sanitized_date_of_birth
          )
        end
      end
    end
  end
end
