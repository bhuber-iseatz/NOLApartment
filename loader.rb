require 'feedzirra'
require 'nokogiri'
require 'open-uri'
require 'geocoder'
require_relative 'apartments'

class CraigsListAd
  attr_accessor :street0, :street1, :city, :state, :latitude, :longitude, :beds,
    :price

  def address
    if @street0
      street = @street0
      street += " at #{@street1}" unless /^\d+ / =~ @street0

      "#{street}, #{@city}, #{@state}"
    end
  end

  def geocode!
    if self.address
      result = Geocoder.search(self.address).first

      if result
        @latitude = result.latitude
        @longitude = result.longitude
      end
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

    body = doc.css('.posting').text

    if body =~ /(?<beds>\d+)\s?(bed|br|bd)/i
      @beds = $~[:beds]
    end

    if body =~/\$(?<price>\d+)/
      @price = $~[:price]
    end
  end
end

class Loader
  def self.run
    feed = Feedzirra::Feed.fetch_and_parse('neworleans.craigslist.org/apa/index.rss')

    feed.entries.map do |entry|
      puts "parsing: #{entry.url}"
      ad = CraigsListAd.new
      ad.parse(entry.url)
      puts "geocoding: #{ad.address}"
      ad.geocode!
      puts "lat/long: #{ad.latitude}, #{ad.longitude}"
      puts "beds #{ad.beds}"
      puts "price #{ad.price}"

      if ad.latitude && ad.longitude
        Apartments.add({
          'url' => entry.url,
          'title' => entry.title,
          'published' => entry.published,
          'beds' => ad.beds,
          'price' => ad.price,
          'latitude' => ad.latitude,
          'longitude' => ad.longitude
        })
      end
    end
  end
end

