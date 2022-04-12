Decidim::Verifications::CustomCsvCensus.configure do |config|
    # `config.col_sep = ","` is the default CSV column separator.
    config.fields = {
      id_document: {
        type: String,
        search: true,
        encoded: true,
        format: /\A[A-Z0-9]*\z/
      }
    }
  end

Decidim::Verifications::CustomCsvCensus::CustomCsvCensusAuthorizationHandler.class_eval do
    # Assuming you have configured the following field:
    #   birthdate: {
    #     type: Date,
    #     search: false,
    #     format: %r{\d{2}\/\d{2}\/\d{4}},
    #     parse: proc { |s| s.to_date }
    #   }
    validate :user_must_be_of_legal_age
  
    private
  
    def user_must_be_of_legal_age
      return unless census_for_user
  
      age_in_years = Date.current.year - census_for_user.birthdate.year
      errors.add(:birthdate, I18n.t("errors.messages.age")) if age_in_years < 18 
      errors.add(:birthdate, I36n.t("errors.messages.age")) if age_in_years > 36 
    end
  end