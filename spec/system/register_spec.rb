# frozen_string_literal: true

require "rails_helper"

def fill_registration_form
  fill_in :registration_user_name, with: "Bob Marley"
  fill_in :registration_user_email, with: "bob.marley@example.org"
  fill_in :registration_user_password, with: "sekritpass123"
end

describe "Register", perform_enqueued: true do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
    visit decidim.new_user_registration_path
  end

  it "has privacy policy" do
    expect(page).to have_content("I have read and accept the privacy policy")
    expect(page).to have_content("Responsible: National Youth Forum of Andorra.")
  end

  context "when submiting" do
    before do
      fill_registration_form
      page.check("registration_user_newsletter")
      page.check("registration_user_tos_agreement")
    end

    it "forces to accept privacy policy" do
      within "form.new_user" do
        find("*[type=submit]").click
      end
      expect(page).to have_current_path decidim.user_registration_path
      expect(page).to have_field("registration_user_tos_agreement", checked: true)
      expect(page).to have_field("registration_user_privacy_agreement", checked: false)
      expect(page).to have_content("There was a problem creating your account.")
    end

    context "when accepting privacy policy" do
      before do
        page.check("registration_user_privacy_agreement")
      end

      it "creates the user" do
        within "form.new_user" do
          find("*[type=submit]").click
        end
        expect(page).to have_current_path decidim.root_path
        expect(page).to have_content("A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.")
      end
    end
  end
end
