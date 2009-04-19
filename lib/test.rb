# this is test.rb referred to above
get '/' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  erb "\n\npoop"
end
 
get '/foo/:bar' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  "\n\nYou asked for foo/#{params[:bar]}"
end
