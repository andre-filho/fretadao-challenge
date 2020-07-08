class Profile < ApplicationRecord
  include PgSearch::Model
  include HTTParty
  include Nokogiri

  validates :name, presence: true
  validates :url, presence: true, uniqueness: true
  validates :image_url, presence: true

  validates :username, presence: true, uniqueness: true
  # the other fields are validated by the validate_(scrapped/url)_fields methods

  pg_search_scope :search_by_term,
    against: [:name, :username, :organizations, :location],
    using: {
      tsearch: {
        any_word: true,
        prefix: true
      }
    }

  # before_save do
  before_validation do
    collect_scrappable_information
    # validate_scrapped_fields
    # validate_url_fields

    # if self.errors.any?
    #   raise ActiveRecord::RecordInvalid.new(self)
    # end
  end


  private

  def collect_scrappable_information
    scrap_profile_data
    self.url = shrink_url(self.url)
    self.image_url = shrink_url(self.image_url)
  end


  def validate_url_fields
    if self.image_url.nil? or self.image_url.empty?
      self.errors.add(:image_url, 'Field not Found')
    end

    if self.url.nil? or self.url.empty?
      self.errors.add(:url, 'Field not Found')
    end

  end


  def shrink_url(url)
    regex_short_urls = /(http:\/\/shorturl\.at\/\w+)/
    regex_github_profile_url = /(github\.com\/\w+)/
    regex_github_image_url = /(githubusercontent\.com\/\w+)/

    if url.nil? or url.empty?
      return url

    elsif url.match(regex_github_profile_url) or url.match(regex_github_image_url)
      # u is the input's name on shorturl.at's form
      raw_page = HTTParty.post('https://www.shorturl.at/shortener.php', body: { u: url })

      parsed_page = Nokogiri::HTML(raw_page.body)
      url = 'http://' + parsed_page.css('#shortenurl').first['value']

    elsif url.match(regex_short_urls)
      # avoid shrinking again on update if url isn't changed
    else
      # url is invalid, forcing a validation error
      url = ''
    end

    return url
  end


  def validate_scrapped_fields
    if self.email.nil?
      self.errors.add(:email, 'Field not Found')
    end

    if self.location.nil?
      self.errors.add(:location, 'Field not Found')
    end

    if self.organizations.nil?
      self.errors.add(:organizations, 'Field not Found')
    end

    if self.username.nil?
      self.errors.add(:username, 'Field not Found')
    end

    if self.contributions.nil? or self.contributions < 0
      self.errors.add(:contributions, 'Field not Found')
    end

    if self.stars.nil? or self.stars < 0
      self.errors.add(:stars, 'Field not Found')
    end

    if self.followers.nil? or self.followers < 0
      self.errors.add(:followers, 'Field not Found')
    end

    if self.subscriptions.nil? or self.subscriptions < 0
      self.errors.add(:subscriptions, 'Field not Found')
    end
  end

  def scrap_profile_data
    raw_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(raw_page.body)

    if parsed_page.css('p').text == 'Not Found'
      # this validation error is treated by the controller
      self.errors.add('404', 'Not Found')
      return
    end

    if parsed_page.css('img.TableObject-item.avatar').any?
      self.errors.add('404', 'Not Found')
      return
    end

    self.username = parsed_page.css('.p-nickname').text
    self.email = parsed_page.css('li.vcard-detail a.u-email').text
    self.location = parsed_page.css('li.vcard-detail span.p-label').text

    # network_interactions => followers, following (subscriptions) and stars
    network_interactions = parsed_page.css('span.text-bold.text-gray-dark')
    contributions = parsed_page.css('h2.f4.text-normal.mb-2')
    image_url = parsed_page.css('img.avatar.avatar-user.border')
    organizations = parsed_page.css('.h-card div .avatar-group-item')

    self.contributions = contributions.empty? ? 0 : contributions[1].text[/[0-9]+/]

    if network_interactions.empty?
      self.stars = 0
      self.followers = 0
      self.subscriptions = 0
    else
      self.stars =  network_interactions[2].text
      self.followers =  network_interactions.first.text
      self.subscriptions =  network_interactions[1].text
    end

    if organizations.any?
      self.organizations = organizations.map { |org| org['aria-label'] }.compact
    end

    # with organizations, image_url breaks
    unless image_url.empty?
      self.image_url = image_url.first['src']
    else
      self.image_url = ''
    end
  end
end
