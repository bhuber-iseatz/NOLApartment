require 'redis'
require 'json'

module Apartments
  KEY = 'apartments'

  def self.all
    self.store.smembers(KEY).map do |member|
      JSON.parse member
    end
  end

  def self.add(apt)
    self.store.sadd(KEY, apt.to_json)
  end

  def self.store
    @@redis ||= Redis.new
  end
end
