require 'twitter'

# !tweet
module BertieBot
  class Tweet
    include Cinch::Plugin
    
    match /tweet (.+)/
    match /tweet\-config (\w+)$/, method: :execute_tweet_config_get
    match /tweet\-config (\w+) (.+)$/, method: :execute_tweet_config_set
    match /tweet\-access$/, method: :execute_tweet_config_set
    
    def initialize(*args)
      super
      @config_options = %w[username consumer_key consumer_secret atoken asecret]
    end
    
    def execute(m, message)
      begin
        client = get_client
      rescue BertieBot::MissingConfigError => e
        m.reply 'tweet is not fully configured'
        m.reply '!tweet-config {username,consumer_key,consumer_secret} <value>'
      end
    end
    
    def execute_tweet_config_get(m, option)
      if !@config_options.include?(option)
        m.reply "unknown option: #{option}"
        return
      end
      
      m.reply "#{option} is set to #{get_config(option)}"
    end
    
    def execute_tweet_config_set(m, option, value)
      if !@config_options.include?(option)
        m.reply "unknown option: #{option}"
        return
      end
      
      set_config(option, value)
      m.reply "#{m.user.nick}: just for you I set #{option} to #{value}"
    end
    
    private
    
    def get_client
      oauth = get_oauth
      Twitter::Base.new(oauth)
    end
    
    def get_oauth
      oauth = Twitter::OAuth.new(get_config(:consumer_key), get_config(:consumer_secret))
      get_access(oauth)
      oauth
    end
    
    def get_access(oauth)
      if get_config(:atoken).nil? or get_config(:asecret).nil?
        rtoken = oauth.request_token.token
        rsecret = oauth.request_token.secret

        puts "go to: http://#{oauth.request_token.authorize_url}"

        puts "give me PIN!"
        pin = gets.to_i

        oauth.authorize_from_request(rtoken, rsecret, pin)

        config[:atoken] = oauth.access_token.token
        config[:asecret] = oauth.access_token.secret
      end
      
      oauth.authorize_from_access(config[:atoken], config[:asecret])
    end
    
    def get_config(name)
      value = ''
      config.transaction(true) do
        value = config[option.to_sym]
      end
      value
    end
    
    def set_config(name, value)
      config.transaction do
        config[option.to_sym] = value
      end
    end
  end
  
  class MissingConfigError < StandardError
  end
end