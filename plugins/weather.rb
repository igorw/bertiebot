# coding: utf-8
require 'google_weather'

# !weather
# !forecast
module BertieBot
  class Weather
    include Cinch::Plugin
    
    match /weather (.+)/
    match /forecast (.+)/, method: :execute_forecast
    
    def execute(m, location)
      begin
        weather = GoogleWeather.new(location)
        forecast = weather.forecast_conditions[0]
        m.reply weather.forecast_information.city + ': ' + pretty_forecast(forecast)
      rescue Exception
        m.reply 'Invalid location'
      end
    end
    
    def execute_forecast(m, location)
      begin
        weather = GoogleWeather.new(location)
        m.reply m.user.nick + ': Forecast for ' + weather.forecast_information.city
        weather.forecast_conditions[0..3].each do |forecast|
          m.reply pretty_forecast(forecast)
        end
      rescue Exception => e
        m.reply 'Invalid location'
        raise e
      end
    end
    
    private
    
    def pretty_forecast(forecast)
      [
        forecast.day_of_week,
        'Low: ' + pretty_temperature(forecast.low),
        'High: ' + pretty_temperature(forecast.high),
        'Condition: ' + forecast.condition
      ].join(' | ')
    end
    
    def pretty_temperature(fahrenheit)
      round_to_one(fahrenheit_to_celsius(fahrenheit)) + '°C (' + fahrenheit.to_s + '°F)'
    end
    
    def fahrenheit_to_celsius(fahrenheit)
      (fahrenheit.to_f - 32.0) / 1.8
    end
    
    def round_to_one(number)
      sprintf('%.1f', number)
    end
  end
end