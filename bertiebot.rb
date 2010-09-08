require 'cinch'

trap("INT") {
	puts
	exit
}

bot = Cinch::Bot.new do
	configure do |c|
		c.nick = "BertieBot-dev"
		c.server = "irc.freenode.org"
		c.channels = ["#bertiebot"]
		
		@last_msg = {}
	end

	# ping
	on :message, "!ping" do |m|
		m.reply "pong!"
	end

	# s/old/new
	on :message, /^s\/(.+)\/(.+)/ do |m, find, replace|
		if !@last_msg[m.user.nick].nil? && @last_msg[m.user.nick].include?(find)
			m.reply @last_msg[m.user.nick].gsub(find, replace)
			@last_msg[m.user.nick] = nil
		end
	end

	# populate @last_msg
	on :message do |m|
		unless /^s\/(.+)\/(.+)/.match(m.message)
			@last_msg[m.user.nick] = m.message
		end
	end

	# quit
	on :message, "!quit" do |m|
		bot.quit "goodbye"
	end
end

bot.start
