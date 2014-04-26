module Ricer::Plugin::Note
  class Note < Ricer::Plug::Trigger
    
    forces_authentication :always => false
    
    has_subcommand :add
    
  end
end