# frozen_string_literal: true

class YouthCensusActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
  def authorize
    return [:missing, { action: :authorize }] if authorization.blank?

    return [:unauthorized, {}] if date_of_birth.blank?

    @fields = { date_of_birth: }
    return [:ok, {}] if age_allowed?

    [:unauthorized, { fields: @fields }]
  end

  private

  def age_allowed?
    age = ((Time.zone.now - Date.parse(date_of_birth).to_time) / 1.year.seconds).floor

    age.between? 16, 35
  rescue StandardError => e
    Rails.logger.error "ACTION AUTHORIZER ERROR: #{e.message}"
  end

  def date_of_birth
    authorization.metadata["date_of_birth"]
  end

  def manifest
    @manifest ||= Decidim::Verifications.find_workflow_manifest(authorization&.name)
  end
end
