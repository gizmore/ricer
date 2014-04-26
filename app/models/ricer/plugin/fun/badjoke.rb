module Ricer::Plugin::Fun
  class Badjoke < Ricer::Plug::FunTrigger
    
    def execute
      case rand(2)
      when 0; rply :badum
      when 1; rply_action :cricket
      when 2; rply_action :tumbleweed
      end
    end
    
  end
end
