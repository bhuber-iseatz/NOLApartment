require 'mongo'

module Apartments
  def self.all
    # TODO find the correct way to do this.
    self.collection.find.select { true }
  end

  def self.add(apt)
    # kinda ghetto
    unless self.collection.find_one('url' => apt['url'])
      self.collection.insert apt
    end
  end

  def self.db
    @@db ||= Mongo::Connection.new.db 'nolapartment'
  end

  def self.collection
    @@store ||= self.db.collection 'apartments'
  end
end
