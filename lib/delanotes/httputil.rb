require 'net/http'
require 'uri'
require 'timeout'


module Delanotes
  module HTTPUtil
    @timeout = 10
    
    def HTTPUtil.hostname(uri_str)
      return if uri_str.empty?
      uri = URI.parse(uri_str)
      #STDERR.puts "Hostname for #{ uri.port }"
      uri.host
    end
    
    # Normalize all URIs before they are used for anything else
    def HTTPUtil.normalize(uri_str, scheme = true) 
      
      
      #STDERR.puts "  BEFORE: " << uri_str
      if (!uri_str.index(/^https?:\/\//))
        uri_str = 'http://' << uri_str
      end
      #STDERR.puts "   AFTER: " << uri_str
      
      uri_str.gsub!(/\s/, '%20')
      
      uri = URI.parse(uri_str)
      
      uri_clean = ""
      
      # TODO: use URI.to_s instead of manually creating the string
      
      if (scheme)
        uri_clean << uri.scheme.to_s + '://'  
      end
      
        
      if (!uri.userinfo.nil?)
        uri_clean << uri.userinfo.to_s
        uri_clean << '@'
      end
      
      uri.host.gsub!(/^www\./, '')
      
      uri_clean << uri.host.to_s
      
      if (!uri.port.nil? && uri.port != 80 && uri.port != 443)
        uri_clean << ':' + uri.port.to_s
      end
      
      
      
      if (!uri.path.nil? && !uri.path.empty?)
        uri_clean << uri.path
      elsif
        uri_clean << '/'
      end
      
      
      if (!uri.query.nil? && !uri.path.empty?)
        uri_clean << "?" << uri.query
      end
      
      #STDERR.puts "IN: " << uri_str
      #STDERR.puts "OUT: " << uri_clean
      
      uri_clean
    end
    
    def HTTPUtil.fetch(uri_str, limit = 10)
       
      # You should choose better exception.
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      
      
      begin
        timeout(@timeout) do
           response = Net::HTTP.get_response(URI.parse(uri_str))
        
        
          case response
          when Net::HTTPSuccess     then response
          when Net::HTTPRedirection then fetch(response['location'], limit - 1)
          else
            STDERR.puts "Error for " << uri_str
          end
        end
      rescue TimeoutError
        STDERR.puts "Net::HTTP timed out for " << uri_str
        return
      end
      
      
      
    end
    
    def HTTPUtil.exists(uri_str)
      STDERR.puts "Requesting: #{uri_str}"
      begin
        response = fetch(uri_str)
        case response
        when Net::HTTPSuccess     then true
        when Net::HTTPRedirection then fetch(response['location'], limit - 1)
        else
          false
        end
        
      rescue Exception => e
        STDERR.puts "Problem: " + e.message
        false
      end
      
    end
    
  end
end
