# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }

  before do
    switch_to_host(organization.host)
    visit decidim.new_user_session_path
  end

  it "has temrs text" do
    expect(page).to have_content("Responsable: Fòrum Nacional de la Joventut d' Andorra.")
  end
end
