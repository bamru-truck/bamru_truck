require 'sinatra/base'
require 'yaml/store'
require 'json'
require 'pp'
require './lib/alert_settings'

STDOUT.sync = true

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
    msg = "Error: no data (#{host})"
    xdata = params[:data]
    (puts msg; pp params; return msg; ) if xdata.nil? || xdata.empty?
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

    def colorbox(color)
      "<span style='color: #{color}; background: #{color};'>[]</span>"
    end

    def pst_color(time)
      now   = Time.parse(Time.now.strftime("%y-%m-%d %H:%M"))
      old   = Time.parse("#{Time.now.year}-#{time}")
      delta = now - old
      case delta  # seconds
      when proc {|n| n < 270} then "green"
      when proc {|n| n < 600} then "yellow"
      else "red"
      end
    end

    def pst(string)
      time  = Time.parse(string.to_s) + Time.zone_offset("PDT")
      time_str = time.strftime("%m-%d %H:%M")
      color = pst_color(time_str)
      time.strftime("%m-%d %H:%M #{colorbox(color)}")
    end

    def freemem_color(pct)
      case pct
      when proc {|n| n > 50} then "green"
      when proc {|n| n > 25} then "yellow"
      else "red"
      end
    end

    def freemem(input)
      all, _used, free = input.split('-')
      pct   = (free.to_f / all.to_f * 100).round
      color = freemem_color(pct)
      val   = pct.to_s + "% free #{colorbox(color)}"
    end

    def has_gps(input)
      return 'true' if input != false
      input
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
