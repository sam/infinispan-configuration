class CacheManager
  
  include_package "org.infinispan.manager"
  include_package "org.infinispan.config"
  include_package "org.infinispan.configuration.global"
  include_package "org.infinispan.configuration.cache"
  include_package "org.infinispan.quickstart.clusteredcache.util"
  
  # EVICTION NOTES:
  # LIRS is the default strategy when an eviction with max-entries is set, per
  #   https://docs.jboss.org/author/display/ISPN/Eviction#Eviction-Configurationanddefaultsin5.1.x
  #
  # So we don't have to worry about setting the strategy through JRuby (which is
  # a problem for some reason as the JRuby::JavaObject reference to the
  # Eviction::LIRS Enum isn't typecast properly).
  #
  # If we want LIRS, just set the max_entries. If you don't want to enable eviction, then
  # either don't max the call, or set max_entries to 0 instead.
  
  CLUSTER_SIZE = 2
  
  def initialize(node_id)
    @node_id = node_id
    @manager = DefaultCacheManager.new(
      GlobalConfigurationBuilder.default_clustered_builder
        .transport
        .add_property("configurationFile", "jgroups-udp.xml")
        .build,
      ConfigurationBuilder.new
        .clustering
        .cache_mode(CacheMode::REPL_SYNC)
        .build
    )

    # @manager.define_configuration "translation",
    #   ConfigurationBuilder.new.read(@default)
    #   .clustering
    #   .cache_mode(CacheMode::REPL_SYNC)
    #   .l1
    #   .eviction
    #   .max_entries(10)
    #   .build
    @translations = @manager.get_cache("translation")
  end
  
  def wait_for_cluster_to_form
    if !ClusterValidation.wait_for_cluster_to_form(@manager, @node_id, CLUSTER_SIZE)
      raise StandardError.new(
        "Error forming cluster, check the log"
      )
    end
  end
   
  def translations
    @translations
  end
end