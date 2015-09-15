require 'sinatra/base'
require 'json'
require 'octokit'
require 'pp'

# Start
# Loop every 10 seconds, check for new message in /queue
# Process (long running)
# Write results to github, then continue looping

class CiWorker

  ACCESS_TOKEN = `git config --global github.patoken`.chomp

  before do
    @client ||= Octokit::Client.new(:access_token => ACCESS_TOKEN)
  end

  post '/event_handler' do

    @payload = JSON.parse(params[:payload] || "{}")

    puts "*" * 75
    pp request.env
    puts "*" * 75
    pp @payload

    case request.env['HTTP_X_GITHUB_EVENT']
    when "pull_request"
      if @payload["action"] == "opened"
        process_pull_request(@payload["pull_request"])
      end
    end
  end

  def process_pull_request(pull_request)
    puts "=" * 75
    puts "Processing pull request..."
    full_name = pull_request['base']['repo']['full_name']
    sha       = pull_request['head']['sha']
    @client.create_status(full_name, sha, 'pending')
    sleep 30 # run CI tests...
    @client.create_status(full_name, sha, 'success')
    puts "=" * 75
    puts "Pull request processed!"
  end
end
