

module Delanotes
  
  attr_reader :flyers
  
  
  class SummariesFlyer < JerkStore::Flyer
    private_class_method :new
    
    attr_accessor :count
    attr_accessor :worthycount
    attr_accessor :notworthycount
    
    def SummariesFlyer.create(args={})

      flyer = new(args)
      
      
      begin
        if flyer.is_readable?
          flyer = flyer.fetch
        end
        
        flyer.count ||= 0
        flyer.worthycount ||= 0
        flyer.notworthycount ||= 0
      rescue Exception => e
        STDERR.puts "Problem getting summary: " << e.message
        STDERR.puts e.backtrace
      end
      
      flyer
      
    end
    
    
    # Developed for mysql migration see Flyer::add_product
    def add_product(p)
      # Adds product to the the Flyer and returns it. 
      ret = super
      
      if (ret != nil)
        @count += 1
        @worthycount += 1 if (p.worthwhile)
        @notworthycount += 1 unless (p.worthwhile)
      end
      
      ret
    end
    
    def update_counts
      @count = 0
      @worthycount = 0
      @notworthycount = 0
      
      self.products.each do |p|
        @count += 1
        @worthycount += 1 if (p.worthwhile)
        @notworthycount += 1 unless (p.worthwhile)
      end
    end
    
    def save
      JerkStore.create_dir(File.dirname(self.path))
      
      #raise "Cannot write to #{ self.path }!" unless is_writeable?
      
      
      # This stuff gets written to disk
      # There's a problem with to_yaml/load_file so 
      # we're storing as a hash and we'll create the object manually.
      tmp = []
      self.products.each do |p|
        tmp << {
          :guid => p.guid, 
          :worthwhile => p.worthwhile,
          :biasedsummary => p.biasedsummary, 
          :biasedperson => p.biasedperson, 
          :datesummarized => p.datesummarized,
          :author => p.author,
          :title => p.title,
          :uri => p.uri
        }
      end
      
      # The hash is only temporary, so we need a copy of the objects
      tmp_products = self.products.dup
      self.products.replace(tmp)
      JerkStore.write_file(self.path, YAML.dump(self))
      self.products.replace(tmp_products)
      
      true
    end
    
    # There's a problem storing nested objects so we use the Flyer#fetch
    # to read in the object, but we need to do some custome manipulation
    # for Summary objects.
    def fetch
      
      newobj = super
      
      # There's a problem with exporting nested objects
      # in YAML so we stored the attribute values of the
      # Summaries and have to recreate the objects here.
      tmp = []
      newobj.products.each do |p|
        tmp << Summary.new(p)
      end
      newobj.products.replace(tmp)
      
      
      newobj.update_counts
      
      #STDERR.puts pp(newobj)
      newobj
      
    end
    
    def initialize(args={})
      super
      
    end
  end

end


