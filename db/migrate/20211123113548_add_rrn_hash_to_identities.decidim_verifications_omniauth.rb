# frozen_string_literal: true
# This migration comes from decidim_verifications_omniauth (originally 20210525110101)

class AddRrnHashToIdentities < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_identities, :rrn_hash, :string
  end
end
