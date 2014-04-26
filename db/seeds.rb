# Supported Timezones
['en', 'de', 'fam', 'bot', 'ibdes'].each do |iso|
  Ricer::Locale.create(iso: iso) unless Ricer::Locale.exists?(iso)
end

# All Encodings
Ricer::Encoding.create(iso: 'UTF-8') unless Ricer::Encoding.exists?('UTF-8')
Encoding.list.each do |encoding|
  Ricer::Encoding.create(iso: encoding.name) unless Ricer::Encoding.exists?(encoding.name)
end

# All Timezones
Ricer::Timezone.create(iso: 'Berlin') unless Ricer::Timezone.exists?('Berlin')
ActiveSupport::TimeZone.all.each do |timezone|
  Ricer::Timezone.create(iso: timezone.name) unless Ricer::Timezone.exists?(timezone.name)
end
    

# Default server :)
# TODO: Make a rake tasks with user input
if Ricer::Irc::Server.in_domain('giz.org').count == 0
  server = Ricer::Irc::Server.create({url:'irc://irc.giz.org:6668'}) 
  nick = Ricer::Irc::Nickname.create({server:server, nickname:'ricer'})
end

if Ricer::Irc::Server.in_domain('freenode.net').count == 0
  server = Ricer::Irc::Server.create({url:'ircs://irc.freenode.net:7000'}) 
  nick = Ricer::Irc::Nickname.create({server:server, nickname:'ricer'})
end

if Ricer::Irc::Server.in_domain('idlemonkeys.net').count == 0
  server = Ricer::Irc::Server.create({url:'ircs://irc.idlemonkeys.net:7000'}) 
  nick = Ricer::Irc::Nickname.create({server:server, nickname:'ricer'})
end

if Ricer::Irc::Server.in_domain('german-elite.net').count == 0
  server = Ricer::Irc::Server.create({url:'ircs://DOminiOn.german-elite.net:6670'}) 
  nick = Ricer::Irc::Nickname.create({server:server, nickname:'ricer'})
end
