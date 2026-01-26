# frozen_string_literal: true

require "rails_helper"

describe Decidim::Elections::Censuses::AndorraCensusForm do
  subject { form }

  let(:form) { described_class.from_params(params).with_context(context) }
  let(:organization) { create(:organization) }
  let(:participatory_process) { create(:participatory_process, organization:) }
  let(:elections_component) { create(:elections_component, participatory_space: participatory_process) }
  let(:election) { create(:election, component: elections_component) }
  let(:context) { { election:, current_user: nil } }

  let(:document_number) { "B123456A" }
  let(:date_of_birth) { Date.new(1995, 3, 15) }
  let(:params) { { document_number:, date_of_birth: } }

  let(:response_body) { { "codiRetorn" => code, "missatgeRetorn" => message } }
  let(:code) { "OK" }
  let(:message) { "" }

  let(:webservice) { instance_double(AndorraWebservice) }
  let(:api_response) { double("response", body: response_body) }

  before do
    allow(AndorraWebservice).to receive(:new).and_return(webservice)
    allow(webservice).to receive(:response).and_return(api_response)
  end

  describe "valid submission" do
    it { is_expected.to be_valid }
  end

  describe "document_number validation" do
    context "when blank" do
      let(:document_number) { nil }

      it { is_expected.to be_invalid }
    end

    context "with invalid format" do
      let(:document_number) { "(╯°□°）╯︵ ┻━┻" }

      it { is_expected.to be_invalid }
    end

    context "with valid format variation" do
      let(:document_number) { "AB123456CD" }

      it { is_expected.to be_valid }
    end
  end

  describe "date_of_birth validation" do
    context "when blank" do
      let(:date_of_birth) { nil }

      it { is_expected.to be_invalid }
    end
  end

  describe "API response handling" do
    context "when API returns date of birth error" do
      let(:code) { "KO" }
      let(:message) { "Error: data de naixement incorrecta" }

      it "adds error to date_of_birth" do
        expect(form).to be_invalid
        expect(form.errors[:date_of_birth]).to be_present
      end
    end

    context "when API returns document error" do
      let(:code) { "KO" }
      let(:message) { "Document not found" }

      it "adds error to document_number" do
        expect(form).to be_invalid
        expect(form.errors[:document_number]).to be_present
      end
    end

    context "when API connection fails" do
      before do
        allow(webservice).to receive(:response).and_raise(Faraday::ConnectionFailed, "connection refused")
      end

      it "adds error to base" do
        expect(form).to be_invalid
        expect(form.errors[:base]).to be_present
      end
    end
  end

  describe "#voter_uid" do
    it "returns an MD5 hash" do
      expect(form.voter_uid).to match(/\A[a-f0-9]{32}\z/)
    end

    it "is deterministic" do
      other_form = described_class.from_params(params).with_context(context)
      expect(form.voter_uid).to eq(other_form.voter_uid)
    end

    it "differs for different documents" do
      uid1 = form.voter_uid

      other_form = described_class.from_params(params.merge(document_number: "C999999Z")).with_context(context)
      uid2 = other_form.voter_uid

      expect(uid1).not_to eq(uid2)
    end

    it "is case-insensitive" do
      form_lower = described_class.from_params(params.merge(document_number: "b123456a")).with_context(context)
      form_upper = described_class.from_params(params.merge(document_number: "B123456A")).with_context(context)

      expect(form_lower.voter_uid).to eq(form_upper.voter_uid)
    end

    context "when document_number is blank" do
      let(:document_number) { nil }

      it "returns nil" do
        expect(form.voter_uid).to be_nil
      end
    end
  end

  describe "API receives sanitized params" do
    it "sends numeric part, letter suffix, and formatted date" do
      form.valid?

      expect(AndorraWebservice).to have_received(:new).with(
        document_number: "123456",
        document_letter: "A",
        date_of_birth: "15/03/1995"
      )
    end
  end

  describe "#election" do
    it "returns the election from context" do
      expect(form.election).to eq(election)
    end
  end
end
