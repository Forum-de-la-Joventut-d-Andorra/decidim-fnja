# frozen_string_literal: true

module AuthorizationStatusCollectionOverride
  extend ActiveSupport::Concern

  included do
    # instead of requiring all authorization to be fulfilled, just one will do
    def ok?
      return true if statuses.blank?

      statuses.any?(&:ok?)
    end
  end
end
