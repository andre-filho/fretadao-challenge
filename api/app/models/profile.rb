class Profile < ApplicationRecord
  include HTTParty
  include Nokogiri

  validates :name, presence: true
  validates :url, presence: true
  validates :gh_username, presence: true

  validates :gh_subscriptions, presence: true
  validates :gh_followers, presence: true
  validates :gh_stars, presence: true
  validates :gh_contributions, presence: true

  validates :image_url, presence: true

  before_validation do
    # ensure all fields are present during validation
    shrink_url
    get_additional_profile_info
  end

  private

  def get_additional_profile_info
    # call scrapper
    raw_page = HTTParty.post(url)
    parsed_page = Nokogiri::HTML(raw_page.body)
    self.gh_username = parsed_page.css('h1.v-card-names span.p-nickname.vcard-username')
  end

  def shrink_url
    if url.match(/(github\.com\/\w+)/)
      # u is the input's name on shorturl
      raw_page = HTTParty.post('https://www.shorturl.at/shortener.php', body: { u: url })
      parsed_page = Nokogiri::HTML(raw_page.body)

      # the shortned url is located inside an input
      print '-----------------------------------------------------------------\n'
      print parsed_page
      print '-----------------------------------------------------------------\n'

      self.url = parsed_page.css('#shortenurl').first['value'] || ''

    elsif url.match(/(https:\/\/shorturl\.at\/shortener\.php)/)
      self.url = ''
    else
      # avoid shrinking again on update
    end
  end

end
