class Profile < ApplicationRecord
  include HTTParty
  include Nokogiri

  validates :name, presence: true

  validates :username, presence: true,
                          uniqueness: true

  validates :url, presence: { message: 'Link is blank or invalid.' },
                  uniqueness: true

  validates :image_url, presence: { message: 'Link is blank or invalid.' }

  validates :subscriptions,  presence: true,
                                numericality: { only_integer: true }

  validates :followers,  presence: true,
                            numericality: { only_integer: true }

  validates :stars,  presence: true,
                        numericality: { only_integer: true }

  validates :contributions,  presence: true,
                                numericality: { only_integer: true }

  before_validation :pre_validations


  private

  def pre_validations
    get_additional_profile_info
    self.url = shrink_url(self.url)
    self.image_url = shrink_url(self.image_url)
  end

  def get_additional_profile_info
      raw_page = HTTParty.get(url)
      parsed_page = Nokogiri::HTML(raw_page.body)

      if parsed_page.css('p').text == 'Not Found'
        errors.add('404', 'Not Found')
        return
      end

      username = parsed_page.css('.p-nickname').text
      contributions = parsed_page.css('h2.f4.text-normal.mb-2')
      email = parsed_page.css('li.vcard-detail a.u-email').text
      location = parsed_page.css('li.vcard-detail span.p-label').text
      image_url = parsed_page.css('img.avatar.avatar-user.border')
      organizations = parsed_page.css('.h-card div .avatar-group-item')
      # network_interactions has the info for followers, following (subscriptions)
      # and stars
      network_interactions = parsed_page.css('span.text-bold.text-gray-dark')

      self.email = email
      self.username = username
      self.location = location
      # since creating an account is a contribution, it should always be shown
      self.contributions = contributions.empty? ? nil : contributions[1].text[/[0-9]+/]
      # the following props doesn't appear on gh profile if their value is 0
      self.stars = network_interactions.empty? ? 0 : network_interactions[2].text
      self.followers = network_interactions.empty? ? 0 : network_interactions.first.text
      self.subscriptions = network_interactions.empty? ? 0 : network_interactions[1].text
      # with organizations, image_url breaks
      self.image_url = image_url.first['src']
      self.organizations = organizations.map { |org| org['aria-label'] }
  end

  def shrink_url(url)
    if url.nil? or url.empty?
      return url

    elsif url.match(/(github\.com\/\w+)/) or url.match(/(githubusercontent\.com\/\w+)/)
      # u is the input's name on shorturl
      raw_page = HTTParty.post('https://www.shorturl.at/shortener.php', body: { u: url })
      parsed_page = Nokogiri::HTML(raw_page.body)
      url = 'http://' + parsed_page.css('#shortenurl').first['value']

    elsif url.match(/(https:\/\/shorturl\.at\/\w+)/)
      # avoid shrinking again on update

    else
      # url is invalid, forcing a validation error
      url = ''
    end

    return url
  end

end
