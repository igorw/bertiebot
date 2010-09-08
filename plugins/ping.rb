# !ping => pong!
module BertieBot
  class Ping
    include Cinch::Plugin
    
    match 'ping'
    
    def execute(m)
      m.reply "pong!"
    end
  end
end