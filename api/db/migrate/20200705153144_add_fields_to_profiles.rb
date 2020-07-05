class AddFieldsToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :gh_organizations, :string, array: true, default: []
    add_column :profiles, :gh_location, :string
    add_column :profiles, :email, :string
  end
end
