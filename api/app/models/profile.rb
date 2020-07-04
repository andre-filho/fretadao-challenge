class Profile < ApplicationRecord
  validates :name, :unique => true, presence: true
  validates :url, :unique => true, presence: true

  before_save :get_additional_profile_info

  private

  def get_additional_profile_info
    # call scrapper
  end
end
