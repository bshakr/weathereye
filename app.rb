require 'sinatra'
require 'faraday'


#index page
get '/' do
  headers "Content-Type" => "text/html; charset=utf-8"
  erb :index
end

#get weather data
get '/forcast/:latitude/:logitude' do
  forecast_url = "https://api.forecast.io/forecast/0fe656d926f844bc4c0745ac4ea9814f/51.275970,1.075610"
  connection = Faraday.new
  forecast = connection.get(forecast_url)
  forecast.body
end