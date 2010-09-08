# !seen
# based on cinch seen example
module BertieBot
  class Seen
    include Cinch::Plugin
    
    listen_to :channel
    match /seen (.+)/
    
    def initialize(*args)
      super
      @users = {}
    end
    
    def listen(m)
      @users[m.user.nick] = SeenStruct.new(m.user, m.channel, m.message, Time.now)
    end
    
    def execute(m, nick)
      if @users.key?(nick)
        m.reply @users[nick].to_s
      else
        m.reply "I haven't seen #{nick}"
      end
    end
  end

  class SeenStruct < Struct.new(:who, :where, :what, :time)
    def to_s
      "#{who} was last seen #{time.to_pretty}"
    end
  end
  
  # relative date
  # http://stackoverflow.com/questions/195740/how-do-you-do-relative-time-in-rails
  module PrettyDate
    def to_pretty
      a = (Time.now-self).to_i
      case a
        when 0 then return 'just now'
        when 1 then return 'a second ago'
        when 2..59 then return a.to_s+' seconds ago' 
        when 60..119 then return 'a minute ago' #120 = 2 minutes
        when 120..3540 then return (a/60).to_i.to_s+' minutes ago'
        when 3541..7100 then return 'an hour ago' # 3600 = 1 hour
        when 7101..82800 then return ((a+99)/3600).to_i.to_s+' hours ago' 
        when 82801..172000 then return 'a day ago' # 86400 = 1 day
        when 172001..518400 then return ((a+800)/(60*60*24)).to_i.to_s+' days ago'
        when 518400..1036800 then return 'a week ago'
      end
      return ((a+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
    end
  end
  
  Time.send :include, BertieBot::PrettyDate
end