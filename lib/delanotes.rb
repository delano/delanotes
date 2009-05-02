# myapp.rb




require 'cgi'
require 'yaml'
require 'digest/sha1'
require 'set'


require 'jerkstore'
require 'summary'
require 'pagecontent'
require 'flyers'
require 'httputil'


module Delanotes
  
  
  def self.new(configuration_file="config/config.yml")
    JerkStore.set_root(self.root + '/data/JerkStore')
      
    @config ||= default_configuration.merge load_config_file(configuration_file)
    
    
    JerkStore.add_flyer(:summaries1day, SummariesFlyer.create({:classtype => 'Delanotes::Summary', :timespan=>'day', :duration => 1}))
    
    JerkStore.add_flyer(:summarieslastweek, SummariesFlyer.create({:classtype => 'Delanotes::Summary', :timespan=>'week', :duration => 1, :offset => -1}))
    
    JerkStore.add_flyer(:summaries1week, SummariesFlyer.create({:classtype => 'Delanotes::Summary', :timespan=>'week', :duration => 1}))
    
    JerkStore.add_flyer(:summaries1month, SummariesFlyer.create({:classtype => 'Delanotes::Summary', :timespan=>'month', :duration => 1}))
    
    JerkStore.add_flyer(:summarieslastmonth, SummariesFlyer.create({:classtype => 'Delanotes::Summary', :timespan=>'month', :duration => 1, :offset => -1}))
    
  end
 
  
  def self.flyers
    @flyers
  end
  
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end
 
  def self.default_configuration
    { :allowed_ages => %w{day week month year lastmonth lastweek} }
  end
 
  def self.config
    @config
  end
  
  def self.load_config_file(file)
    YAML.load_file(file)
  rescue Errno::ENOENT
    {}
  end
  
  # When do I need this??
  #autoload :JerkStore, 'jerkstore'
end

