require 'feedzirra'
require 'nokogiri'
require 'open-uri'
require 'geocoder'
require_relative 'apartments'

class CraigsListAd
  attr_accessor :street0, :street1, :city, :state, :latitude, :longitude

  def address
    if @street0
      street = @street0
      street << " & #{@street1}" unless /^\d+ / =~ @street0

      "#{street}, #{@city}, #{@state}"
    end
  end

  def geocode!
    if self.address
      result = Geocoder.search(self.address).first
      @latitude = result.latitude
      @longitude = result.longitude
    end

    self
  end

  def parse(url)
    doc = Nokogiri::HTML(open(url))
    doc.xpath('//comment()').each do |comment|
      case comment
      when /CLTAG xstreet0=(?<street0>.*)/
        @street0 = $~[:street0]
      when /CLTAG xstreet1=(?<street1>.*)/
        @street1 = $~[:street1]
      when /CLTAG city=(?<city>.*)/
        @city = $~[:city]
      when /CLTAG region=(?<region>.*)/
        @state = $~[:region]
      end
    end
  end
end


feed = Feedzirra::Feed.fetch_and_parse('neworleans.craigslist.org/apa/index.rss')

feed.entries.map do |entry|
  ad = CraigsListAd.new
  ad.parse(entry.url)
  ad.geocode!

  if ad.latitude && ad.longitude
    Apartments.add({
      'url' => entry.url,
      'title' => entry.title,
      'published' => entry.published,
      'latitude' => ad.latitude,
      'longitude' => ad.longitude
    })
  end
end
