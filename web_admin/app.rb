require 'sinatra/base'

# $PROGRAM_NAME = 'web_admin_d'  # set the process name

class WebAdmin < Sinatra::Base
  enable :logging
  set :bind, '0.0.0.0'           # listen on any interface

  helpers do
    def link_to_unless_current(path, label)
      return label if path == request.path_info
      "<a href='#{path}'>#{label}</a>"
    end

    def navdata
      %w(/:Home /erb:ERB_TEST /time:Time /ls:LS /gps_packets:20_GPS_Packets /cell_modem_status:Cell_Modem_Status)
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

  get '/gps_packets' do
    erb `gpspipe -r -n 10`.gsub("\n","<br/>")
  end

  get '/cell_modem_status' do
    erb `/usr/bin/sudo /bin/get-modem-status.py --html`.gsub("\n","<br/>")
  end

end

