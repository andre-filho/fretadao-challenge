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

  before_validation :get_additional_profile_info
  before_save :shrink_url

  private

  def get_additional_profile_info
    # call scrapper
    raw_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(raw_page.body)
    self.gh_username = parsed_page.css('.p-nickname').text
    self.gh_followers = parsed_page.css('span.text-bold.text-gray-dark').first.text.to_i
    self.gh_subscriptions = parsed_page.css('span.text-bold.text-gray-dark')[1].text.to_i
    self.gh_stars = parsed_page.css('span.text-bold.text-gray-dark')[2].text.to_i
    self.gh_contributions = parsed_page.css('h2.f4.text-normal.mb-2')[1].text[/[0-9]+/].to_i
    self.image_url = parsed_page.css('img.avatar.avatar-user.border').first['src']
  end

  # TODO: shrink img url too
  def shrink_url
    if url.match(/(github\.com\/\w+)/)
      # u is the input's name on shorturl
      raw_page = HTTParty.post('https://www.shorturl.at/shortener.php', body: { u: url })
      parsed_page = Nokogiri::HTML(raw_page.body)

      # the shortned url is located inside an input
      self.url = parsed_page.css('#shortenurl').first['value'] || ''

    elsif url.match(/(https:\/\/shorturl\.at\/shortener\.php)/)
      self.url = ''
    else
      # avoid shrinking again on update
    end
  end

end
