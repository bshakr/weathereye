require 'sinatra'
require 'faraday'
require 'nokogiri'
require 'json'

#index page
get '/' do
  headers "Content-Type" => "text/html; charset=utf-8"
  erb :index
end


#get city location
get '/find/city/:city' do
  yahoo_appid = 'pmQ_VnzV34FddFT6do_XVxcjzkrjmeKzNpJjLP1MqfPSEN6yCN0vunwBt8QbZYWEc65EPzD6o8VVmDYXTQZbPY0DkXSGUO4-'
  city_url = "http://where.yahooapis.com/v1/places.q('#{params[:city]}')?appid=#{yahoo_appid}"
  puts "#{city_url}"
  connection = Faraday.new
  response = connection.get(city_url)
  document = Nokogiri::XML(response.body)
  puts "#{document}"
  latitude = document.xpath('//places/place/centroid/latitude').text
  longitude = document.xpath('//places/place/centroid/longitude').text
  puts "latitude: #{latitude}"
  puts "longitude: #{longitude}"
  {:latitude => latitude, :longitude => longitude}.to_json
end

#get weather data
get '/forecast/:latitude/:longitude' do
  forecast_url = "https://api.forecast.io/forecast/0fe656d926f844bc4c0745ac4ea9814f/#{params[:latitude]},#{params[:longitude]}"
  connection = Faraday.new
  forecast = connection.get(forecast_url)
  forecast.body
end