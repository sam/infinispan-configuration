require "java"

java_import org.infinispan.Cache
java_import org.infinispan.manager.DefaultCacheManager
cache = DefaultCacheManager.new.get_cache

cache["foo"] = "bar"
p cache.keys