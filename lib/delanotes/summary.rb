

module Delanotes
  class Summary < JerkStore::Product
  
    attr_accessor :datesummarized
    attr_accessor :biasedsummary
    attr_accessor :biasedperson
    attr_accessor :title
    attr_accessor :author
    attr_reader :uri
    attr_reader :worthwhile
    
    
    def initialize(args = {})
      
      args[:biasedperson] ||= "delano"
      args[:worthwhile] ||= false
      
      unless args.empty?
        
        
        args.each do |n,v|
          next unless self.respond_to? "#{n}="
          #STDERR.puts '2 n: ' + n.to_s + ':' + v.to_s
          
          v = "" unless v
          
          self.send("#{n}=", v) 
          
          #pp n.to_s + ":" + v.to_s + ":" + (self.respond_to? n).to_s
          
        end
        
      end
      
      self.clean!
      
      return
    end
    

    def clean!
      
      if (!self.datesummarized)
        self.datesummarized = DateTime.now
      end

        
      return
    end
    
    def save
      is_saved = super
      
      is_saved
    end
    
    
    
    def valid?
      true
    end
    
    def worthwhile=(v)
      @worthwhile = (v == true || (!v.nil? && v.eql?('true')))
      @worthwhile
    end
    
    def uri=(t_uri)
      return if (t_uri.nil? || t_uri.empty?)
      
      t_uri = HTTPUtil.normalize(t_uri)
      
      @uri = t_uri
      
      @uri
    end

    protected
    def seed
      self.uri if self.uri
    end
    def shelf
      HTTPUtil.hostname(self.uri) if self.uri
    end
  end

end


