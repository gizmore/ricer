module Ricer::Plug
  class BaseIrc < Base
    
    protected
    
    def lib; Ricer::Irc::Lib.instance; end

    def bold(text); lib.bold(text); end
    def strip_tags(text); lib.strip_tags(text); end
   
  end
end
