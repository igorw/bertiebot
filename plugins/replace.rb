# s/old/new
module BertieBot
  class Replace
    include Cinch::Plugin
    
    listen_to :channel
    prefix ''
    match /^s\/(.+)\/(.+)/
    
    def initialize(*args)
      super
      @last_msg = {}
    end

    # populate @last_msg
    def listen(m)
      if /^s\/(.+)\/(.+)/.match(m.message) || /^!/.match(m.message)
  			return
  		end
  		@last_msg[m.user.nick] = m.message
    end
    
    def execute(m, find, replace)
  		if !@last_msg[m.user.nick].nil? && @last_msg[m.user.nick].include?(find)
  			m.reply @last_msg[m.user.nick].gsub(find, replace)
  			@last_msg[m.user.nick] = nil
  		end
    end
  end
end