# !note
# !getnotes
module BertieBot
  class Note
    include Cinch::Plugin
    
    listen_to :join
    match /note (.+?) (.+)/
    match 'getnotes', method: :execute_getnotes
    
    def initialize(*args)
      super
      @notes = {}
    end
    
    def listen(m)
      if @notes.key?(m.user.nick) && @notes[m.user.nick].size > 0
        m.reply "#{m.user.nick}: You have notes type !getnotes to retrieve them."
      end
    end
    
    def execute(m, nick, note)
      if !@notes.key?(nick)
  	    @notes[nick] = []
      end
      @notes[nick] << MemoStruct.new(m.user.nick, m.channel, note, Time.now)
      m.reply "Your note has been left for #{nick}"
    end
    
    def execute_getnotes(m)
      if @notes.key?(m.user.nick) && @notes[m.user.nick].size > 0
        for note in @notes[m.user.nick]
          m.reply note.to_s
        end
        @notes[m.user.nick] = []
      else
        m.reply "No notes for you"
      end
    end
  end
  
  class MemoStruct < Struct.new(:nick, :channel, :text, :time)
    def to_s
      "[#{time.asctime}] <#{nick}> #{text}"
    end
  end
end