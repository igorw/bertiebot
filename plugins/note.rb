# !note
# !getnotes
module BertieBot
  class Note
    include Cinch::Plugin
    
    listen_to :join
    match /note (.+?) (.+)/
    match 'getnotes', method: :execute_getnotes
    match 'checknotes', method: :execute_checknotes
    
    def initialize(*args)
      super
      @notes = Hash.new {|h,k| h[k] = []}
    end
    
    def listen(m)
      if @notes.key?(m.user.nick) && @notes[m.user.nick].size > 0
        m.reply "#{m.user.nick}: You have notes, type !getnotes to retrieve them."
      end
    end
    
    def execute(m, nick, note)
      @notes[nick] << MemoStruct.new(m.user.nick, m.channel, note, Time.now)
      m.reply "Your note has been left for #{nick}"
    end
    
    def execute_getnotes(m)
      if @notes.key?(m.user.nick)
        while note = @notes[m.user.nick].shift
          bot.msg m.user.nick, note.to_s
        end
        @notes[m.user.nick] = []
      else
        m.reply "No notes for you"
      end
    end
    
    def execute_checknotes(m)
      if @notes.key?(m.user.nick) && @notes[m.user.nick].size > 0
        m.reply "I have notes for you"
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