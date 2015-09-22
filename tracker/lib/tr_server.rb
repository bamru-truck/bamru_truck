require 'sinatra/base'
require 'yaml/store'
require 'json'
require 'pp'
require './lib/alert_settings'

class TrServer < Sinatra::Base

  ROOT_DIR    = File.expand_path("#{File.dirname(__FILE__)}/../")
  DATA_DIR    = ROOT_DIR + "/data"
  HOST_STORE  = DATA_DIR + "/hosts.yml"
  ALERT_STORE = DATA_DIR + "/alerts.yml"

  set :root, ROOT_DIR

  get '/' do
    redirect to('/data')
  end

  get '/data' do
    erb :data
  end

  get '/alerts' do
    @alert_settings = alert_settings
    erb :alerts
  end

  post '/heartbeat/:hostname' do
    host = params[:hostname]
    data = JSON.parse(params[:data])
    save_host(host, data)
    "OK\n"
  end

  post '/set_alerts' do
  end

  post '/set_alertable' do
  end

  helpers do
    def alert_settings
      return AlertSettings.new unless File.exist?(ALERT_STORE)
      AlertSettings.new(YAML.load_file(ALERT_STORE) || {})
    end

    def host_store
      @host_store ||= YAML::Store.new HOST_STORE
    end

    def all_hosts
      @all_hosts ||= YAML.load_file(HOST_STORE)
    end

    def get_host(host)
      all_hosts[host]
    end

    def save_host(host, data)
      data["time"] ||= Time.now.utc
      host_store.transaction do
        host_store[host] = data
      end
    end

    def pst(string)
      (Time.parse(string.to_s) + Time.zone_offset("PDT")).strftime("%m-%d %H:%M")
    end

    def freemem(input)
      all, _used, free = input.split('-')
      (free.to_f / all.to_f * 100).round.to_s + "% free"
    end

    def maplink(data)
      "<a href='http://maps.google.com?q=#{data['lat']},#{data['lon']}'>map</a>"
    end

    def linkto(path, label)
      rpath = request.env["REQUEST_PATH"]
      if path == rpath
        label
      else
        "<a href='#{path}'>#{label}</a>"
      end
    end
  end
end
