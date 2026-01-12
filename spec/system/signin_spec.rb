# frozen_string_literal: true

require "rails_helper"

describe "Signin", perform_enqueued: true do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
    visit decidim.new_user_session_path
  end

  it "has terms text" do
    expect(page).to have_content("Responsible: National Youth Forum of Andorra.")
  end
end
