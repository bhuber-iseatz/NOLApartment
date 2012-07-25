require 'rubygems'
require 'sinatra'
require 'rufus/scheduler'
require 'json'

require_relative 'loader'
require_relative 'apartments'

scheduler = Rufus::Scheduler.start_new

scheduler.every '2h' do
  Loader.run
end

get '/' do
  erb :index
end

get '/apartments' do
  Apartments.all.to_json
end
