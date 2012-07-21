require 'mongo'

module Apartments
  def self.all
    # TODO find the correct way to do this.
    self.collection.find.select { true }
  end

  def self.add(apt)
    self.collection.insert apt
  end

  def self.db
    @@db ||= Mongo::Connection.new.db 'nolapartment'
  end

  def self.collection
    @@store ||= self.db.collection 'apartments'
  end
end
