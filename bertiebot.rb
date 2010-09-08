require 'bundler'

Bundler.setup

require 'cinch'
require './plugins/ping'
require './plugins/replace'
require './plugins/quit'
require './plugins/seen'

trap("INT") {
	puts
	exit
}

bot = Cinch::Bot.new do
	configure do |c|
		c.nick = "BertieBot-dev"
		c.server = "irc.freenode.org"
		c.channels = ["#bertiebot"]
		c.plugins.plugins = [
		  BertieBot::Ping,
      BertieBot::Replace,
      BertieBot::Quit,
      BertieBot::Seen
		]
	end
end

bot.start
