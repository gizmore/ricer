module Ricer::Plug

  Ricer::Plug::Base.extend Ricer::Plug::Extender::BruteforceProtected
  Ricer::Plug::Base.extend Ricer::Plug::Extender::ForcesAuthentication
  Ricer::Plug::Base.extend Ricer::Plug::Extender::HasSetting
  Ricer::Plug::Base.extend Ricer::Plug::Extender::HasSubcommand
  Ricer::Plug::Base.extend Ricer::Plug::Extender::IsSubcommand
  Ricer::Plug::Base.extend Ricer::Plug::Extender::MaxCharacters
  Ricer::Plug::Base.extend Ricer::Plug::Extender::NeedsPermission
  Ricer::Plug::Base.extend Ricer::Plug::Extender::RequiresConfirmation
  Ricer::Plug::Base.extend Ricer::Plug::Extender::RequiresRetype
  Ricer::Plug::Base.extend Ricer::Plug::Extender::ScopeIs
  Ricer::Plug::Base.extend Ricer::Plug::Extender::TriggerIs
  
  class Command < BaseSettings

  end
  
end
