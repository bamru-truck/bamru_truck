require 'yaml'

class Track

  ROOT_DIR    = File.expand_path("#{File.dirname(__FILE__)}/../")
  DATA_DIR    = ROOT_DIR + "/data"

  attr_accessor :host, :name, :distance, :duration, :points

  def initialize(host, name)
    @host     = host
    @name     = name
    if File.exist?(track_file)
      load_file
    else
      @distance = 0
      @duration = 0
      @points   = []
    end
  end

  def add_point(opts)
    pnt  = {}
    pnt["lat"]  = opts["lat"]
    pnt["lon"]  = opts["lon"]
    pnt["alt"]  = opts["alt"]
    pnt["time"] = opts["time"]
    @distance   = new_distance(opts)
    @duration   = new_duration(opts)
    @points << pnt
    save
  end

  def to_gpx
    head = "<gpx><trk><name>#{@name}</name><trkseg>"
    tail = "</trkseg></trk></gpx>"
    pnts = points.map {|p| gtx_point(p)}.join
    head + pnts + tail
  end

  private

  # ----- paths and directories -----

  def track_dir
    DATA_DIR + "/#{host}"
  end

  def track_file
    track_dir + "/#{name}.yml"
  end

  # ----- serialization -----

  def to_yaml
    obj = {}
    obj["name"] = name
    obj["host"] = host
    obj["duration"] = duration
    obj["distance"] = distance
    obj["points"]   = points
    obj.to_yaml
  end

  def gtx_point(point)
    <<-EOF.gsub(/^ {4}/,'').gsub("\n","")
    <trkpt lat='#{point["lat"]}' lon='#{point["lon"]}'>
      <ele>#{point["alt"]}</ele>
      <time>#{point["time"]}</time>
    </trkpt>
    EOF
  end

  # ----- persistence -----

  def load_file
    obj      = YAML.load_file(track_file)
    @name     = obj["name"]
    @distance = obj["distance"] || 0
    @duration = obj["duration"] || 0
    @points   = obj["points"]   || []
  end

  def save
    system "mkdir -p #{track_dir}"
    File.open(track_file, 'w') {|f| f.puts to_yaml}
  end

  # ----- state -----

  def new_distance(obj)
    0
  end

  def new_duration(obj)
    0
  end

  def vector_length(obj)
    0
  end
end
