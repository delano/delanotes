#
#
#TODO
#- add request delanote to not found summary
#- caching: http://groups.google.com/group/sinatrarb/browse_thread/thread/d39a786e62f75119/69164aa4f8c01407?pli=1
#
#
require 'authorization'
require 'pp'

set :root,   "lib"
set :public, "public"
set :views,  "views"


include Delanotes
include HTTPUtil

configure do
  Delanotes.new
end

not_found do
  status 404
  @title = "Lost?"
  erb :notfound
end

before do
  
  params[:age] = 'week' if params[:age] && !Delanotes.config[:allowed_ages].member?(params[:age])

  # The browser only sends http auth data for requests that are explicitly
  # required to do so. This way we get the real values of +#logged_in?+ and
  # +#current_user+
  login_required if session[:user]
  
end


get '/audio*' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  
  @title = "Some stuff I hear!"
  @audio_path = "#{Delanotes.root}/public/audio_files"
  
  erb :audio
end

# Show by URI 
get '/summary/*' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  header 'X-Content-Type' => "Delano sexy time"
  
  
  if params[:uri]
    uri_str = params[:uri]
  else
    uri_str = params["splat"].join()
    uri_str.gsub!(/http(s?):\/(\w)/, 'http\1://\2')

    if (!request.env['QUERY_STRING'].nil? && !request.env['QUERY_STRING'].empty?)
      uri_str << '?' << request.env['QUERY_STRING']
    end
  end
  
  uri_str = d uri_str
  
  STDERR.puts "URL: #{ uri_str }"
  
  begin
    @summary =  self.summary_by_uri(uri_str)
    header 'Content-Type' => 'text/plain; charset=utf-8'
    @summary.to_yaml
  rescue Exception
    @errmsg = "I don't have a summary for<br/><strong>#{ h uri_str }</strong>"
    @summaries = current_summaries
    erb :show
  end
end

# Show all summaries
get '/summary*' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  #@total = total_summaries
  erb :show
end

get '/feed.atom' do 
  header 'Content-Type' => 'application/atom+xml; charset=utf-8'
  header 'X-Content-Type' => "Delano sexy time"
  
  @summaries = current_summaries
  erb :show, :views_directory => "#{Delanotes.root}/views/atom", :layout => :layout
end


# display new content form
get '/delanonly/newcontent' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  #login_required
  
  begin
    @content = content_by_path(params[:uripath])
    @content = PageContent.new(params) if @content.nil?
  
  rescue Exception => e
    STDERR.puts "Problem getting content: " << e.message
  end  
  
  erb :newcontent, :layout => :layout_delanonly
end

# Create and save new content
post '/delanonly/newcontent*' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  #login_required
  
  @content = PageContent.new(params)
  
  if !@content.nil? && @content.save

    redirect "/" + @content.uripath
  else
    @errmsg = ""
    
    if (@content.has_errors?)
      @content.errors.each do |e|
        e.each do |msg|
          @errmsg << msg.to_s << "<br/>"
        end
        
        end
    else
      @errmsg << "Unexpected error"
      end
    end
  erb(:newcontent, :layout => :layout_delanonly)
  
end

# display new delanote form
get '/delanonly/newdelanote' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  #login_required
  
  layout :layout_delanonly
  
  @summary = Summary.new(params)
  #pp @summary
  
  begin
    if (!params[:uri].nil? && @summary.is_readable?)
      @errmsg = "Duplicate URI"
    end
  
  rescue Exception => e
    STDERR.puts "Problem getting summary: " << e.message
  end  
  
  erb :newdelanote, :layout => :layout_delanonly
end

# create new object and store it
post '/delanonly/newdelanote' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  #login_required
  
  @summary = Summary.new(params)
  
  
  if (!params[:ignore] && !HTTPUtil.exists(@summary.uri))
    @errmsg = "Invalid URI: " << @summary.uri
  
  elsif (!@summary.nil? && @summary.is_readable?)
    @errmsg = "Duplicate URI: " << @summary.uri
    
  elsif @summary.save
    uri_tmp = HTTPUtil.normalize(@summary.uri, true)
    
    
    JerkStore.update_flyers(@summary)
    
    redirect "/summary/#{uri_tmp}"
  else
    @errmsg = ""
    
    if (@summary.has_errors?)
      @summary.errors.each do |e|
        e.each do |msg|
          @errmsg << msg.to_s << "<br/>"
        end
        
        end
    else
      @errmsg << "Unexpected error"
      end
    end
  erb(:new, :layout => :layout_delanonly)
end


# new
get '/' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  header 'X-Content-Type' => "Delano sexy time"
  @title = authorization_realm
  #http://local.delanotes.com:4566/?age=<script>alert(3)</script>
  ## params[:age] is: day, week, month
  
  @age = params[:age]
  @age ||= "week"
    
  @summaries = current_summaries(@age)
  
  # Maybe there's nothing new today
  unless (@summaries.length > 0)
    if ("day".eql?(@age))
      redirect "/?age=week"
    elsif ("week".eql?(@age))
      redirect "/?age=month"
    elsif ("month".eql?(@age))
      redirect "/?age=lastmonth"
    end
  end
  
  #STDERR.puts pp(@summaries)
  ##@total = total_summaries
  
  erb :show
end


get '/*' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  header 'X-Content-Type' => "Delano sexy time"
  
  @content = content_by_path(params[:splat][0])
  
  if !@content.nil?
    @title = @content.title
    erb :content
  else 
    erb :notfound
  end
  
end


helpers do
  include Rack::Utils
  include Sinatra::Authorization
  #include CGI
  alias_method :h, :escape_html
  alias_method :e, :escape
  alias_method :d, :unescape
  
  def authorization_realm
    "Delanotes.com: Biased summaries of URIs"
  end
  
  def authorize(user, password)
    if Delanotes.config[:hash_admin_password]
      password = Digest::SHA1.hexdigest(password)
    end
 
    Delanotes.config[:admin_username] == user &&
      Delanotes.config[:admin_password] == password
  end
  
  def unauthorized!(realm=authorization_realm)
    header 'WWW-Authenticate' => %(Basic realm="#{realm}")
    throw :halt, [401, erb(:unauthorized, :title => "incorrect credentials")]
  end




  def current_summaries(age='week') 
    
    flyer = flyer_by_timespan(age)
    
    #STDERR.puts "SUMMARIES FOR #{age}: " + flyer.products.length.to_s
    
    flyer.products
  end 
  
  def count_summaries(age='week',worthwhile=nil)
    
    flyer = flyer_by_timespan(age)
    
    if (!flyer)
      return 0
    end
    
    if (worthwhile.nil?)
      flyer.count
    elsif(worthwhile)
      flyer.worthycount
    elsif(!worthwhile)
      flyer.notworthycount
    end
  end
  
  def flyer_by_timespan(age='week')
    flyers = JerkStore.get_flyers
    
    # See delanotes.rb for the available flyers
    if flyers.has_key? :"summaries1#{age}"
      flyers[:"summaries1#{age}"]
    elsif flyers.has_key? :"summaries#{age}"
      flyers[:"summaries#{age}"] 
    end
    
  end
  
  def content_by_path(path)
    newobj = PageContent.new(:uripath => path)
    n = newobj.fetch if newobj.is_readable?
  end
  
  def summary_by_uri(uri_str)
    newobj = Summary.new(:uri => uri_str)
    n = newobj.fetch
    #STDERR.puts pp(n)
    return n
  end  
end
