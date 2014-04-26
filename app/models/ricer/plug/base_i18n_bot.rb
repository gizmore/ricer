module Ricer::Plug
  class BaseI18nBot < BaseI18nIbdes
    
    protected
    
    def _tt_bot(args)
      args.shift + ':' + args.shift.inspect + 'X'
    end
    
  end
end
