require 'sinatra'

helpers do
  def link_to_unless_current(path, label)
    return label if path == request.path_info
    "<a href='#{path}'>#{label}</a>"
  end

  def hdrs
    %w(/:Home /erb:ERB_TEST /time:Time /ls:LS)
  end
end

get '/' do
  erb "Hello World"
end

get '/erb' do
  erb :erb_test
end

get '/time' do
  erb "Current Time: #{Time.now}"
end

get '/ls' do
  erb `ls -1`.gsub("\n","<br/>")
end

