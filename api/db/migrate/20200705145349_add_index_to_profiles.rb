class AddIndexToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_index :profiles, :url, unique: true
    add_index :profiles, :gh_username, unique: true
  end
end
