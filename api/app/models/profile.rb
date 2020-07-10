require 'shorturl'
require 'httparty'
require 'nokogiri'

class Profile < ApplicationRecord
  include PgSearch::Model

  validates :name, presence: true
  validates :username, :url, :image_url, presence: true, uniqueness: true

  before_validation :gather_information_from_github

  pg_search_scope :search_by_term,
                    against: [:name, :username, :organizations, :location],
                    using: {
                      tsearch: {
                        any_word: true,
                        prefix: true
                      }
                    }

  private

  def gather_information_from_github
    unless self.url.nil? or self.url.empty?
      scrap_profile_data
      self.url = shrink_url(self.url)
    end
  end

  def shrink_url(url)
    regex_short_urls = /(http:\/\/tinyurl\.com\/\w+)/
    regex_github_profile_url = /(github\.com\/\w+)/
    regex_github_image_url = /(githubusercontent\.com\/\w+)/

    if url.nil? or url.empty?
      return url

    elsif url.match(regex_github_profile_url) or url.match(regex_github_image_url)
      url = ShortURL.shorten(url, :tinyurl)
    elsif url.match(regex_short_urls)
      # avoid shrinking again on update if url isn't changed
    else
      url = ''  # force validation error
    end

    return url
  end

  def scrap_profile_data
    raw_page = HTTParty.get(self.url)
    parsed_page = Nokogiri::HTML(raw_page.body)

    validate_webpage_as_profile(parsed_page)
    set_personal_data(parsed_page)
    set_social_data(parsed_page)
  end

  def set_personal_data(parsed_html)
    self.username = parsed_html.css('.p-nickname').text
    self.email = parsed_html.css('li.vcard-detail a.u-email').text
    self.location = parsed_html.css('li.vcard-detail span.p-label').text
    image_url = parsed_html.css('img.avatar.avatar-user.border')

    unless image_url.empty?
      self.image_url = shrink_url(image_url.first['src'])
    end
  end

  def set_social_data(parsed_html)
    # network_interactions => followers, following (subscriptions) and stars
    network_interactions = parsed_html.css('span.text-bold.text-gray-dark')
    contributions = parsed_html.css('h2.f4.text-normal.mb-2')
    organizations = parsed_html.css('.h-card div .avatar-group-item')

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
  end

  def validate_webpage_as_profile(page)
    if page.css('p').text == 'Not Found' or page.css('img.TableObject-item.avatar').any?
      self.errors.add('404', 'Not Found')
      :abort
    end
  end

end
