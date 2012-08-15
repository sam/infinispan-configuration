#!/usr/bin/env jruby

require "pathname"

if Pathname($0).basename.to_s == "jar-bootstrap.rb"
  $:.unshift Pathname(__FILE__).dirname
  Dir["target/dependency/*.jar"].each { |jar| require jar }
end

require "java"
require "configuration"

cluster_name = ARGV[0]
node_id = ARGV[1].to_i

manager = CacheManager.new(cluster_name, node_id)
translations = manager.translations
manager.wait_for_cluster_to_form

translations["message"] = "Waiting..."

if node_id == 1
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