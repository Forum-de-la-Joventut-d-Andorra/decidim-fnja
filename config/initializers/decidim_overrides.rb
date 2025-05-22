# frozen_string_literal: true

# Precompile does not have access to a database so we avoid overrides
if ENV["DB_ADAPTER"].blank? || ENV.fetch("DB_ADAPTER", nil) == "postgresql"
  Rails.application.config.to_prepare do
    Decidim::RegistrationForm.include(RegistrationFormOverride)
    Decidim::ActionAuthorizer::AuthorizationStatusCollection.include(AuthorizationStatusCollectionOverride)
  end
end
