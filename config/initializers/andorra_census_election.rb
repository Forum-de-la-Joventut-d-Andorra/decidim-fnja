# frozen_string_literal: true

require "digest/md5"

Rails.application.config.after_initialize do
  next unless defined?(Decidim::Elections)

  Decidim::Elections.census_registry.register(:andorra_census) do |manifest|
    manifest.admin_form = "Decidim::Elections::Admin::Censuses::AndorraCensusForm"
    manifest.admin_form_partial = "decidim/elections/admin/censuses/andorra_census_form"
    manifest.voter_form = "Decidim::Elections::Censuses::AndorraCensusForm"
    manifest.voter_form_partial = "decidim/elections/censuses/andorra_census_form"

    manifest.census_ready_validator do |_election|
      true
    end

    manifest.voter_uid_generator do |data|
      document_number = data["document_number"] || data[:document_number]
      next if document_number.blank?

      Digest::MD5.hexdigest("#{document_number.to_s.upcase}-#{Rails.application.secret_key_base}")
    end

    manifest.user_validator do |_election, data|
      document_number = data["document_number"] || data[:document_number]
      date_of_birth = data["date_of_birth"] || data[:date_of_birth]
      document_number.present? && date_of_birth.present?
    end
  end
end
