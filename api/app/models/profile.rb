class Profile < ApplicationRecord
  include HTTParty
  include Nokogiri

  validates :gh_username, presence: true,
                          uniqueness: true
  validates :url, presence: { message: 'Link is blank or invalid.' },
                  uniqueness: true

  validates :image_url, presence: { message: 'Link is blank or invalid.' }
  validates :name, presence: true
  validates :gh_subscriptions, presence: true
  validates :gh_followers, presence: true
  validates :gh_stars, presence: true
  validates :gh_contributions, presence: true

  before_validation :pre_validations

  private
  def pre_validations
    get_additional_profile_info
    self.url = shrink_url(self.url)
    self.image_url = shrink_url(self.image_url)
  end


  def get_additional_profile_info
    begin
      raw_page = HTTParty.get(url)
      parsed_page = Nokogiri::HTML(raw_page.body)

      self.gh_username = parsed_page.css('.p-nickname').text
      self.gh_followers = parsed_page.css('span.text-bold.text-gray-dark').first.text.to_i
      self.gh_subscriptions = parsed_page.css('span.text-bold.text-gray-dark')[1].text.to_i
      self.gh_stars = parsed_page.css('span.text-bold.text-gray-dark')[2].text.to_i
      self.gh_contributions = parsed_page.css('h2.f4.text-normal.mb-2')[1].text[/[0-9]+/].to_i
      self.image_url = parsed_page.css('img.avatar.avatar-user.border').first['src']
    rescue
      # TODO: in case of not finding the required elements
    end
  end

  def shrink_url(url)
    if url.match(/(github\.com\/\w+)/) or url.match(/(githubusercontent\.com\/\w+)/)
      # u is the input's name on shorturl
      raw_page = HTTParty.post('https://www.shorturl.at/shortener.php', body: { u: url })
      parsed_page = Nokogiri::HTML(raw_page.body)
      url = parsed_page.css('#shortenurl').first['value']

    elsif url.match(/(https:\/\/shorturl\.at\/\w+)/)
      # avoid shrinking again on update

    else
      # url is invalid, so it will return a validation error
      url = ''
    end

    return url
  end

end
