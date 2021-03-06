BASE  = File.dirname(File.expand_path(__FILE__))
TFILE = "/tmp/token.txt"

require "sinatra/base"
require "rbconfig"
require "#{BASE}/lib/helpers"

class WebAdmin < Sinatra::Base

  enable  :logging
  set     :bind, '0.0.0.0'           # listen on any interface
  helpers AppHelpers

  get '/' do
    erb :home
  end

  get '/token' do
    @token = File.exist?(TFILE) ? File.read(TFILE) : "Undefined"
    erb :token_form
  end

  post '/token' do
    @token = params["new_token"]
    puts params
    File.write(TFILE, @token)
    redirect '/token'
  end

  get '/gps_packets' do
    raspi_only do
      safe_exec { erb `gpspipe -r -n 10`.gsub("\n","<br/>") }
    end
  end

  get '/cell_modem_status' do
    raspi_only do
      safe_exec { erb `/usr/bin/sudo /bin/get-modem-status.py --html` }
    end
  end
end

