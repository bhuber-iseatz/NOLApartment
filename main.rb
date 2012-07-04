require 'rubygems'
require 'sinatra'
require_relative 'apartments'


get '/' do
  erb :index
end

get '/apartments' do
  Apartments.all
end
