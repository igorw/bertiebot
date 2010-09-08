# !quit
module BertieBot
  class Quit
    include Cinch::Plugin
    
    match 'quit'
    
    def execute(m)
      @bot.quit "goodbye"
    end
  end
end