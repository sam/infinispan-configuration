require "singleton"

class CacheManager
  include Singleton
  
  include_package "org.infinispan.manager"
  include_package "org.infinispan.configuration.cache"
  
  def initialize
    @manager = DefaultCacheManager.new
    
    # LIRS is the default strategy when an eviction with max-entries is set, per
    #   https://docs.jboss.org/author/display/ISPN/Eviction#Eviction-Configurationanddefaultsin5.1.x
    #
    # So we don't have to worry about setting the strategy through JRuby (which is
    # a problem for some reason as the JRuby::JavaObject reference to the
    # Eviction::LIRS Enum isn't typecast properly).
    #
    # If we want LIRS, just set the max_entries. If you don't want to enable eviction, then
    # either don't max the call, or set max_entries to 0 instead.
    @manager.define_configuration "translation", ConfigurationBuilder.new.eviction.max_entries(10).build
    @translations = @manager.get_cache("translation")
  end
   
  def translations
    @translations
  end
end