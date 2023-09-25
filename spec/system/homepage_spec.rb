# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }

  before do
    page.driver.browser.execute_cdp(
      "Network.deleteCookies",
      domain: ".#{organization.host}",
      name: Decidim.consent_cookie_name,
      path: "/"
    )

    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    expect(page).to have_content("Home")
  end

  it "has the cookies message" do
    within("#dc-dialog-wrapper") do
      expect(page).to have_content("Information about the cookies used on the website")
    end
  end

  it "discards the data consent" do
    click_button(id: "dc-dialog-accept")
    expect(page).not_to have_content("Information about the cookies used on the website")
  end
end
