module Ricer::Plugin::Quote
  class Votedown < Ricer::Plug::Trigger
    
    trigger_is 'quote--'
    needs_permission :authenticated
    
    def execute
      
      quote = Quote.where(:id => argv[0]).first
      return rplyp :err_quote if quote.nil?
      
      quote.disliked_by user
      return rplyp :err_vote unless quote.vote_registered?
      
      return relyp :msg_voted
      
    end
    
  end
end