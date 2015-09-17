require 'sinatra/base'
require 'json'
require 'octokit'
require 'pp'


class CiServer < Sinatra::Base

  BASE_DIR = File.dirname(__FILE__)

  # Accept Webhook posts for github, write contents to log/<sha>.json
  post '/event_handler' do

    @json_env = request.env.to_json
    @json_pl  = params[:payload] || "{}"
    @payload  = JSON.parse(@json_pl)

    puts "*" * 75
    pp request.env
    puts "*" * 75
    pp @payload

    case request.env['HTTP_X_GITHUB_EVENT']
    when "pull_request"
      if @payload["action"] == "opened"
        queue_pull_request(@payload["pull_request"])
      end
    end
  end

  # Display a directory of CI runs from /history
  get '/' do
    "UNDER CONSTRUCTION"
  end

  # Display a single CI run from /history
  get '/ci_show/:sha' do
    "UNDER CONSTRUCTION (#{sha})"
  end

  helpers do
    def queue_pull_request(pull_request)
      sha = pull_request['head']['sha']
      system "mkdir -p #{BASE_DIR}/queue"
      File.open("#{BASE_DIR}/queue/#{sha}.json", 'w') do |f|
        f.puts @json_pl
      end
    end
  end
end
