module Ricer::Plug::Extender::ScopeIs
  def scope_is(scope)
    class_eval do |klass|
      throw "Invalid scope '#{scope}' for '#{klass.name}' for Extender 'WorksIn'." if Ricer::Irc::Scope.by_name(scope).nil?
      klass.class_variable_set('@@SCOPE', scope)
    end      
  end
end
