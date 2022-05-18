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
    @census_url ||= Rails.application.secrets.dig(:census, :url)
  end

  def census_username
    @census_username ||= Rails.application.secrets.dig(:census, :username)
  end

  def census_password
    @census_password ||= Rails.application.secrets.dig(:census, :password)
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
