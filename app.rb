require 'typhoeus'
require 'pry'
require 'sinatra'

get '/' do
  erb :index
end

post '/download' do
  binding.pry
end
