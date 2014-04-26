module Ricer::IrcFonts
  
  def bold(text)
    return "\x02#{text}\x02"
  end
  
  def italic(text)
    return "\x04#{text}\x04"
  end
  
  
end
