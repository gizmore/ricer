module Ricer::Plugin::Art
  class Cowsay < Ricer::Plug::Trigger
    
    bruteforce_protected

    needs_permission :halfop
    
    has_setting :image, type: :enum, scope: :user, permission: :halfop, enums:[:kitten,:frog], default: :kitten
    
    def execute
      out = exec('cowsay --', argline)
      puts out
      puts out.inspect
    end
    
  end
end
