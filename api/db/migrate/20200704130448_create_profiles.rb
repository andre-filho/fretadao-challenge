class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :url
      t.string :gh_username
      t.integer :gh_followers
      t.integer :gh_subscriptions
      t.integer :gh_stars
      t.integer :gh_contributions
      t.string :image_url

      t.timestamps
    end
  end
end
