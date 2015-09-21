require 'sinatra/base'
require 'json'
require 'pp'

$PROGRAM_NAME = "HGCI_SERVER"

class CiServer < Sinatra::Base

  ROOT_DIR  = File.expand_path("#{File.dirname(__FILE__)}/../")
  HIST_GLOB = ROOT_DIR + "/history/*"

  set :root, ROOT_DIR

  # Accept Webhook posts for github, write contents to log/<sha>.json
  post '/event_handler' do
    @json_env = request.env.to_json
    @json_pl  = params[:payload] || "{}"
    @payload  = JSON.parse(@json_pl)

    case request.env['HTTP_X_GITHUB_EVENT']
    when "pull_request"
      if @payload["action"] == "opened"
        queue_pull_request(@payload["pull_request"])
      end
    end
  end

  # Display a directory of CI runs from /history
  get '/' do
    @files = hist_files
    if @files.empty?
      "Current Time: #{Time.now} - NO CONTENT"
    else
      erb :directory
    end
  end

  # Display a single CI run from /history
  get '/sha/:sha' do
    sha = params[:sha]
    tgt_file = "./history/#{sha}.txt"
    if File.exist?(tgt_file)
      send_file tgt_file
    else
      "FILE NOT FOUND: #{sha}"
    end
  end

  helpers do
    def queue_pull_request(pull_request)
      sha = pull_request['head']['sha']
      system "mkdir -p #{ROOT_DIR}/queue"
      File.open("#{ROOT_DIR}/queue/#{sha}.json", 'w') do |f|
        f.puts @json_pl
      end
    end

    def hist_files
      Dir[HIST_GLOB].sort_by {|f| File.mtime(f)}.reverse  # newest first
    end
  end
end
