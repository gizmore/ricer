namespace :ricer do
  desc "Startup the ricer bot"
  task start: :environment do

    bot = Ricer::Bot.instance
    
    bot.log_info "Starting up the ricer bot."
    bot.rice_up

    bot.log_info "Raisins!"
    bot.run

  end

  task testrepo: :environment do
    
    bot = Ricer::Bot.instance
    
    bot.log_info "Starting up the ricer bot."
    bot.rice_up
    
    repo = Ricer::Plugin::Cvs::Repo.find(3)
    
    
  end
  
  task websocket: :environment do
    provider = Ricer::Net::WsProvider.new
  end

end
