module Ricer::Plug
  class Oneliner < Trigger
    def self.init_min_max; set_min_max(0, 255); end
    def execute; show_help; end
    def help; tp self.class.name; end
    def usage; help; end
    def full_usage; help; end
    def description; help; end
  end
end
