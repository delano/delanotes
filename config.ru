# This file goes in delanotes.com/config.ru

# Uncomment the vendor copy of Sinatra to use the gem version (the
# git copy of sinatra is located in the vendor directory)
$: << File.expand_path(File.dirname(__FILE__) + "/vendor/sinatra/lib")
$: << File.expand_path(File.dirname(__FILE__) + "/vendor/rack/lib")
$: << File.expand_path(File.dirname(__FILE__) + "/vendor")
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


