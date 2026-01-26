# frozen_string_literal: true

require "rails_helper"
require "decidim/elections/test/vote_examples"

describe "Andorra census voting" do
  let!(:election) { create(:election, :published, :ongoing, census_manifest: "andorra_census") }
  let(:webservice) { instance_double(AndorraWebservice) }
  let!(:question1) { create(:election_question, :with_response_options, election:, question_type: "single_option") }
  let!(:question2) { create(:election_question, :with_response_options, election:, question_type: "multiple_option") }
  let(:organization) { election.organization }
  let(:document_number) { "B123456A" }
  let(:voter_uid) { Digest::MD5.hexdigest("#{document_number.upcase}-#{Rails.application.secret_key_base}") }

  let(:election_path) { Decidim::EngineRouter.main_proxy(election.component).election_path(election) }
  let(:new_election_vote_path) { Decidim::EngineRouter.main_proxy(election.component).new_election_vote_path(election_id: election.id) }
  let(:confirm_election_votes_path) { Decidim::EngineRouter.main_proxy(election.component).confirm_election_votes_path(election_id: election.id) }

  def election_vote_path(question)
    Decidim::EngineRouter.main_proxy(election.component).election_vote_path(election_id: election.id, id: question.id)
  end

  before do
    allow(AndorraWebservice).to receive(:new).and_return(webservice)
    switch_to_host(organization.host)
    visit election_path
  end

  def fill_andorra_census_form
    fill_in "Document number", with: document_number
    fill_in_datepicker :andorra_census_date_of_birth_date, with: "15/03/1995"
    click_on "Access"
  end

  context "when credentials are valid" do
    let(:api_response) { double("response", body: { "codiRetorn" => "OK", "missatgeRetorn" => "" }) }

    before do
      allow(webservice).to receive(:response).and_return(api_response)
    end

    it "allows the user to vote" do
      click_on "Vote"
      expect(page).to have_current_path(new_election_vote_path)
      expect(page).to have_content("Verify your identity")
      expect(page).to have_content("Document number")
      expect(page).to have_content("Date of birth")

      fill_andorra_census_form
      fill_in_votes
    end
  end

  context "when document number is invalid" do
    let(:api_response) { double("response", body: { "codiRetorn" => "KO", "missatgeRetorn" => "Document not found" }) }

    before do
      allow(webservice).to receive(:response).and_return(api_response)
    end

    it "shows a document error" do
      click_on "Vote"
      fill_andorra_census_form

      expect(page).to have_content("The document number is not valid or is not in the census")
      expect(page).to have_current_path(new_election_vote_path)
    end
  end

  context "when date of birth is invalid" do
    let(:api_response) { double("response", body: { "codiRetorn" => "KO", "missatgeRetorn" => "Error: data de naixement incorrecta" }) }

    before do
      allow(webservice).to receive(:response).and_return(api_response)
    end

    it "shows a date of birth error" do
      click_on "Vote"
      fill_andorra_census_form

      expect(page).to have_content("The date of birth is not valid")
      expect(page).to have_current_path(new_election_vote_path)
    end
  end

  context "when census service is unavailable" do
    before do
      allow(webservice).to receive(:response).and_raise(Faraday::ConnectionFailed, "connection refused")
    end

    it "shows a connection error" do
      click_on "Vote"
      fill_andorra_census_form

      expect(page).to have_content("The census service is temporarily unavailable")
      expect(page).to have_current_path(new_election_vote_path)
    end
  end
end
