require 'sinatra/base'
require 'yaml/store'
require 'json'
require 'pp'
require './lib/alert_settings'
require './lib/track'

STDOUT.sync = true

class TrServer < Sinatra::Base

  ROOT_DIR    = File.expand_path("#{File.dirname(__FILE__)}/../")
  DATA_DIR    = ROOT_DIR + "/data"
  HOST_STORE  = DATA_DIR + "/hosts.yml"
  ALERT_STORE = DATA_DIR + "/alerts.yml"

  set :root, ROOT_DIR

  get '/' do
    erb :home
  end

  get '/about' do
    erb :about
  end

  get '/location' do
    redirect '/'
  end

  get '/location/:hostname' do
    @hostname = params[:hostname]
    @hostdata = get_host(@hostname)
    @lat = @hostdata["lat"]
    @lon = @hostdata["lon"]
    @coords = "[#{@lat},#{@lon}]"
    erb :location_map
  end

  get '/tracks' do
    redirect '/'
  end

  get '/tracks/:hostname' do
    @hostname = params[:hostname]
    @hostdata = get_host(@hostname)
    @lat = @hostdata["lat"]
    @lon = @hostdata["lon"]
    @coords = "[#{@lat},#{@lon}]"
    @tracks   = Dir.glob(DATA_DIR + "/#{@hostname}/*.yml").map {|f| File.basename(f, ".yml")}
    erb :track_map
  end

  get '/tracks/:hostname/:trackid' do
    @hostname = params[:hostname]
    @tracks   = Dir.glob(DATA_DIR + "/#{@hostname}/*.yml").map {|f| File.basename(f, ".yml")}
    @trackid  = params[:trackid]
    @trackobj = Track.new(@hostname, @trackid)
    @gpx      = @trackobj.to_gpx
    erb :track_map
  end

  get '/data/:hostname' do
    @hostname = params[:hostname]
    @hostdata = get_host(@hostname)
    erb :host
  end

  get '/alerts' do
    @alert_settings = alert_settings
    erb :alerts
  end

  post '/heartbeat/:hostname' do
    new_host = params[:hostname]
    new_data = JSON.parse(params[:data] || "{}")
    old_data = get_host(new_host) || {}
    msg = "Error: no data (#{new_host})"
    (puts msg; pp params; return msg; ) if new_data.empty?
    tgt_data = gen_data(old_data, new_data)
    save_host(new_host, tgt_data)
    update_track(new_host, tgt_data, old_data)
    "OK\n"
  end

  get '/tbd' do
    erb :tbd
  end


  helpers do

    # ----- misc -----

    def alert_settings
      return AlertSettings.new unless File.exist?(ALERT_STORE)
      AlertSettings.new(YAML.load_file(ALERT_STORE) || {})
    end

    # ----- persistence -----

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
      host_store.transaction do
        host_store[host] = data
      end
    end

    # ----- movement -----

    def new_pos?(old_val, new_val)
      return true if old_val.nil? || new_val.nil?
      dlat = (old_val["lat"].to_f.abs - new_val["lat"].to_f.abs).abs
      dlon = (old_val["lon"].to_f.abs - new_val["lon"].to_f.abs).abs
      dvec = Math.sqrt(dlat ** 2 + dlon ** 2)
      dvec > 0.0003  # 30 meters...
    end

    def has_moved?(old_data, new_data)
      return true if old_data.nil? || new_data.nil?
      return true if old_data["moved_at"].nil?
      delta = Time.now.utc - old_data["moved_at"] # in seconds
      new_pos?(old_data, new_data) || delta < 180 # three minutes
    end

    def gen_data(old_data, new_data)
      now = Time.now.utc
      tgt_data = old_data.merge(new_data)
      tgt_data["time"] = now
      tgt_data["status"] = has_moved?(old_data, new_data) ? "moving" : "stationary"
      tgt_data["moved_at"]      ||= now
      tgt_data["moved_at"]        = now if new_pos?(old_data, new_data)
      tgt_data["transition_at"] ||= now
      tgt_data["transition_at"]   = now if old_data["status"] != tgt_data["status"]
      tgt_data
    end

    # ----- tracks -----

    def update_track(host, tgt_data, old_data)
      return if tgt_data["status"] == "stationary"
      name = tgt_data["transition_at"].strftime("%Y-%m-%d_%H:%M:%S")
      track = Track.new(host,name)
      track.add_point(old_data) if track.points.nil? || track.points.empty?
      track.add_point(tgt_data)
    end

    def count_tracks(host)
      hostdir = DATA_DIR + "/#{host}"
      return 0 unless Dir.exist?(hostdir)
      count = Dir.glob("#{hostdir}/*.yml").count
      return 0 if count == 0
      "<a href='/tracks/#{host}'>#{count}</a>"
    end

    # ----- string helpers -----

    def pluralize(count, singular, plural)
      count.to_s == "1" ? singular : plural
    end

    def time_ago_in_words(t1, t2)
      s = t1.to_i - t2.to_i # distance between t1 and t2 in seconds
      resolution = if s > 29030400       # seconds in a year
                     [(s/29030400), 'years']
                   elsif s > 2419200
                     [(s/2419200), 'months']
                   elsif s > 604800
                     [(s/604800), 'weeks']
                   elsif s > 86400
                     [(s/86400), 'days']
                   elsif s > 3600         # seconds in an hour
                     [(s/3600), 'hours']
                   elsif s > 60
                     [(s/60), 'mins']
                   else
                     [s, 'seconds']
                   end
      if resolution[0] == 1               # singular v. plural
        resolution.join(' ')[0...-1]
      else
        resolution.join(' ')
      end
    end

    def pst(string)
      time  = Time.parse(string.to_s) + Time.zone_offset("PDT")
      time_str = time.strftime("%m-%d %H:%M")
      color = pst_color(time_str)
      time.strftime("%m-%d %H:%M")
    end

    # ----- view helpers -----

    def pst_color(time)
      now   = Time.parse(Time.now.strftime("%y-%m-%d %H:%M"))
      old   = Time.parse("#{Time.now.year}-#{time}")
      delta = now - old
      case delta  # seconds
      when proc {|n| n < 270} then "lightgreen"
      when proc {|n| n < 600} then "lightyellow"
      else "pink"
      end
    end

    def status_color(data)
      return "" unless data["status"] == "moving"
      "style='background:lightblue;'"
    end

    def status_box(data)
      line1 = data["status"] == 'moving' ? 'moving' : 'stationary'
      trans = data["transition_at"]
      return line1 if trans.nil?
      line2 = "for #{time_ago_in_words(Time.now.utc, trans)}"
      "#{line1}<br/>#{line2}"
    end

    def uptime(input)
      input.gsub('_',' ').gsub('min', 'mins')
    end

    def freemem(input)
      all, _used, free = input.split('-')
      pct   = (free.to_f / all.to_f * 100).round
      pct.to_s + "% free"
    end

    def has_gps(input)
      return 'true' if input != false
      input
    end

    def mapbox_img(coords)
      token = 'pk.eyJ1IjoiYW5keWwiLCJhIjoiY2lmenFocnBtNjI1YnV1a3NpczAwNG1obSJ9.SFko9FkIWOxD4nqsGlpx5w'
      size  = '180X60'
      base  = 'api.mapbox.com/v4/mapbox.streets'
      icon  = 'pin-s-circle+482'
      "<img src='https://#{base}/#{icon}(#{coords})/#{coords},8/180x60.png?access_token=#{token}'/>"
    end

    def mapimg(data)
      lat    = data["lat"].to_s[0..4]
      lon    = data["lon"].to_s[0..6]
      coords = "#{lon},#{lat}"
      mapbox_img(coords)
    end

    # ----- link helpers -----

    def maplink(host, data)
      "<a href='/location/#{host}'>#{mapimg(data)}</a>"
    end

    def hostlink(host)
      "<a href='/data/#{host}'>map</a>"
    end

    def navlink
      "#{linkto('/',  'home')} | #{linkto('/about', 'about')}"
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
