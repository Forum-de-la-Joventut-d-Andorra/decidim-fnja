# frozen_string_literal: true

require "rails_helper"

describe YouthCensusActionAuthorizer do
  let(:subject) { described_class.new(authorization, {}, nil, nil).authorize }
  let(:authorization) { create :authorization, :granted, name: "census_authorization_handler", metadata: metadata }
  let(:metadata) do
    { "date_of_birth" => date_of_birth }
  end
  let(:date_of_birth) { 18.years.ago.to_date.to_s }

  describe "authorize" do
    context "when age is allowed" do
      it { is_expected.to eq([:ok, {}]) }
    end

    context "when authorization is missing" do
      let(:authorization) { nil }

      it { is_expected.to eq([:missing, { action: :authorize }]) }
    end

    context "when date_of_birth is missing" do
      let(:date_of_birth) { nil }

      it { is_expected.to eq([:unauthorized, {}]) }
    end

    context "when age is not allowed" do
      let(:date_of_birth) { 36.years.ago.to_date.to_s }

      it { is_expected.to eq([:unauthorized, { fields: { date_of_birth: date_of_birth } }]) }

      context "when age is tricky" do
        let(:date_of_birth) { Time.zone.parse("2004-12-10").to_date.to_s }
        let(:now) { Time.zone.parse("2020-12-09") }

        before do
          allow(Time.zone).to receive(:now).and_return(now)
        end

        it { is_expected.to eq([:unauthorized, { fields: { date_of_birth: date_of_birth } }]) }

        context "and is in the range" do
          let(:now) { Time.zone.parse("2020-12-11") }

          it { is_expected.to eq([:ok, {}]) }
        end
      end
    end
  end
end
