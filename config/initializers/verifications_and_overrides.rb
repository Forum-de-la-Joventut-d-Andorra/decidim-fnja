# frozen_string_literal: true

# We are using the same DirectVerifications engine without the admin part to
# create a custom verification method called "direct_verifications_managers"
# Decidim::Verifications.register_workflow(:direct_verifications_managers) do |workflow|
#   workflow.engine = Decidim::DirectVerifications::Verification::Engine
# end

Decidim::Verifications.register_workflow(:census_authorization_handler) do |workflow|
  workflow.form = "CensusAuthorizationHandler"
  workflow.action_authorizer = "YouthCensusActionAuthorizer"
end

# We need to tell the plugin to handle this method in addition to the default "Direct verification". Any registered workflow is valid.
Decidim::DirectVerifications.configure do |config|
  config.manage_workflows = %w(direct_verifications id_documents)

  # change the to the metadata_parser if you want it
  # config.input_parser = :metadata_parser
end
# Remove NIE from id_documents form
Decidim::Verifications.configure do |config|
  config.document_types = %w(DNI passport)
end

# Precompile does not have access to a database so we avoid overrides
if ENV["DB_ADAPTER"].blank? || ENV.fetch("DB_ADAPTER", nil) == "postgresql"
  Rails.application.config.to_prepare do
    Decidim::RegistrationForm.include(RegistrationFormOverride)
    Decidim::ActionAuthorizer::AuthorizationStatusCollection.include(AuthorizationStatusCollectionOverride)
  end
end
