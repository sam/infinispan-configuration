require "singleton"

class CacheManager
  include Singleton
  
  include_package "org.infinispan.manager"
  
  def initialize    
    @translations = DefaultCacheManager.new("infinispan.xml").get_cache("translation")
  end
   
  def translations
    @translations
  end
end