require 'sinatra'

$PROGRAM_NAME = 'web_admin_d'  # set the process name
set :bind, '0.0.0.0'           # listen on any interface

helpers do
  def link_to_unless_current(path, label)
    return label if path == request.path_info
    "<a href='#{path}'>#{label}</a>"
  end

  def navdata
    %w(/:Home /erb:ERB_TEST /time:Time /ls:LS)
  end

  def navbar
    navdata.map do |el|
      link_to_unless_current(*el.split(':'))
    end.join(' | ')
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

