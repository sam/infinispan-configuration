#!/usr/bin/env jruby

require "pathname"

if Pathname($0).basename.to_s == "jar-bootstrap.rb"
  $:.unshift Pathname(__FILE__).dirname
  Dir["target/dependency/*.jar"].each { |jar| require jar }
end

require "java"
require "configuration"

translations = CacheManager.instance.translations

11.times do |i|
  translations[i.to_s] = rand(10_000).to_s
end

p translations.keys.sort