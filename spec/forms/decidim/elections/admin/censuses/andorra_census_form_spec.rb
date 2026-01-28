# frozen_string_literal: true

require "rails_helper"

describe Decidim::Elections::Admin::Censuses::AndorraCensusForm do
  subject { form }

  let(:form) { described_class.from_params({}) }

  describe "#census_settings" do
    it "returns an empty hash" do
      expect(form.census_settings).to eq({})
    end
  end

  it "is always valid" do
    expect(form).to be_valid
  end
end
