module Delanotes
  class PageContent < JerkStore::Product
    
    attr_accessor :title, :body, :overwrite
    attr_reader :uripath
    
    def initialize(args = {})
      
      unless args.empty?
         
        args.each do |n,v|
          next unless self.respond_to? "#{n}="
          
          v = "" unless v
          
          self.send("#{n}=", v) 
          
        end
        
      end
    end
    
    def uripath=(v)
      v.gsub!(/\/$/, '') # remove trailing slash
      @uripath = v
    end
    
    protected
    def seed
      self.uripath if self.uripath
    end
    def shelf
      self.uripath.split('/')[0] if self.uripath
    end
  end
  
  
end
