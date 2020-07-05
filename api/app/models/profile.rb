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
    begin
      raw_page = HTTParty.get(url)
      parsed_page = Nokogiri::HTML(raw_page.body)

      self.username = parsed_page.css('.p-nickname').text
      self.followers = parsed_page.css('span.text-bold.text-gray-dark')
                                      .first.text.to_i
      self.subscriptions = parsed_page.css('span.text-bold.text-gray-dark')[1]
                                          .text.to_i
      self.stars = parsed_page.css('span.text-bold.text-gray-dark')[2]
                                  .text.to_i
      self.contributions = parsed_page.css('h2.f4.text-normal.mb-2')[1]
                                          .text[/[0-9]+/].to_i
      self.image_url = parsed_page.css('img.avatar.avatar-user.border')
                                  .first['src']
      self.organizations = parsed_page.css('.h-card div .avatar-group-item')
                                          .map { |org| org['aria-label'] }
      self.email = parsed_page.css('li.vcard-detail a.u-email').text
      self.location = parsed_page.css('li.vcard-detail span.p-label').text

    rescue
      # raises validation error if required profile info is not found
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def shrink_url(url)
    if url.match(/(github\.com\/\w+)/) or url.match(/(githubusercontent\.com\/\w+)/)
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
