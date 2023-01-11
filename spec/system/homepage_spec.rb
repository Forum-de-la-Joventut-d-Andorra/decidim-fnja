# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    expect(page).to have_content("Home")
  end

  it "has a link to the cookies page" do
    within ".cookie-warning" do
      expect(page).to have_link("Find out more about cookies", href: "/pages/cookies")
    end
  end
end
