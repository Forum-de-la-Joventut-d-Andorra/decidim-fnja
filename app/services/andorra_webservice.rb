# frozen_string_literal: true

class AndorraWebservice
  def initialize(document_number:, document_letter:, date_of_birth:)
    @params = {
      NIA: document_number,
      lletraClau: document_letter,
      dataNaixement: date_of_birth
    }
  end

  attr_accessor :params
  attr_writer :census_url, :census_username, :census_password

  def census_url
    @census_url ||= ENV.fetch("CENSUS_URL", nil)
  end

  def census_username
    @census_username ||= ENV.fetch("CENSUS_USERNAME", nil)
  end

  def census_password
    @census_password ||= ENV.fetch("CENSUS_PASSWORD", nil)
  end

  def response
    return @response if defined?(@response)

    begin
      conn = Faraday.new(census_url) do |f|
        f.request :authorization, :basic, census_username, census_password
        f.response :json
        f.params = params
      end
      @response = conn.get
      raise Faraday::Error, @response.body["Errors"].join(" ") if @response.body["Errors"].present?

      @response
    rescue Faraday::Error => e
      Rails.logger.error "WEBSERVICE CONNECTION ERROR: #{e.message}"
      throw e
    end
  end
end
