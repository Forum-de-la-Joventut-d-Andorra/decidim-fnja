# frozen_string_literal: true

module RegistrationFormOverride
  extend ActiveSupport::Concern

  included do
    attribute :privacy_agreement, ActiveRecord::Type::Boolean
    validates :privacy_agreement, allow_nil: false, acceptance: true
  end
end
