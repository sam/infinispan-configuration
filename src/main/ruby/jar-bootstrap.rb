#!/usr/bin/env jruby

require "pathname"

if Pathname($0).basename.to_s == "jar-bootstrap.rb"
  $:.unshift Pathname(__FILE__).dirname
  Dir["target/dependency/*.jar"].each { |jar| require jar }
end

require "java"
require "configuration"

node_id = ARGV[0] ? 1 : 0

manager = CacheManager.new(node_id)
translations = manager.translations
manager.wait_for_cluster_to_form

translations["message"] = "Waiting..."

if ARGV[0] == "sleep"
  puts "What do you want to say?"
  while !(message = STDIN.gets).strip.empty? do
    translations["message"] = message
  end
  translations.clear
else
  while translations["message"] do
    puts translations["message"]
    sleep 5
  end
end