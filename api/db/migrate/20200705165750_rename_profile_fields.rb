class RenameProfileFields < ActiveRecord::Migration[6.0]
  def change
    rename_column :profiles, :gh_username, :username
    rename_column :profiles, :gh_followers, :followers
    rename_column :profiles, :gh_subscriptions, :subscriptions
    rename_column :profiles, :gh_stars, :stars
    rename_column :profiles, :gh_contributions, :contributions
    rename_column :profiles, :gh_organizations, :organizations
    rename_column :profiles, :gh_location, :location
  end
end
