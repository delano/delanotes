# This file goes in delanotes.com/config.ru


ENV['GEM_PATH'] = '/home/delano/.gems:/usr/local/lib/site_ruby/1.8:/usr/local/lib/site_ruby/1.8/i386-linux:/usr/local/lib/site_ruby:/usr/lib/ruby/1.8:/usr/lib/ruby/1.8/i386-linux'


# Uncomment the vendor copy of Sinatra to use the gem version (the
# git copy of sinatra is located in the vendor directory)
$: << File.expand_path("/home/delano/.gems")
$: << File.expand_path("/home/delano/.gems/gems")
$: << File.expand_path("/home/delano/.gems/gems/dm-core-0.9.3/lib")
$: << File.expand_path("/usr/lib/ruby/1.8/i386-linux")
$: << File.expand_path("/usr/lib/ruby/1.8")
$: << File.expand_path("/usr/local/lib/site_ruby/1.8/i386-linux")
$: << File.expand_path("/usr/local/lib/site_ruby")
$: << File.expand_path("/usr/local/lib/site_ruby/1.8")
$: << File.expand_path("/usr/local/lib/ruby/gems/1.8/gems")
$: << File.expand_path("/usr/lib/ruby/gems/1.8/gems/sqlite3-ruby-1.2.1/lib")
$: << File.expand_path(File.dirname(__FILE__) + "/vendor/sinatra/lib")
$: << File.expand_path(File.dirname(__FILE__) + "/vendor/rack/lib")
$: << File.expand_path(File.dirname(__FILE__) + "/vendor")
$: << File.expand_path(File.dirname(__FILE__) + "/vendor/jerkstore/lib")
$: << File.expand_path(File.dirname(__FILE__) + "/lib")
$: << File.expand_path(File.dirname(__FILE__) + "/lib/delanotes")

#STDERR.puts $:

require 'rubygems'
require "sinatra"
require "delanotes"

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => 'production',
  #:views => ,
  #:public => ,
  :raise_errors => true
)

#log = File.new("log/sinatra.log", "a")
#STDOUT.reopen(log)
#STDERR.reopen(log)

require 'lib/delanotes/api.rb'
#require 'lib/test.rb'
run Sinatra.application


