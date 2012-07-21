require 'rubygems'
require 'sinatra'
require 'json'
require_relative 'apartments'


get '/' do
  erb :index
end

get '/apartments' do
  Apartments.all.to_json
end
