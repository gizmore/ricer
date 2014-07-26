require 'uri'
class URI::Generic
  def domain(parts=2)
    self.host.split('.').slice(-parts, parts).join('.')
  end
end
