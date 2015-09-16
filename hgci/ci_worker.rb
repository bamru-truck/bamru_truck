#!/usr/bin/env ruby

require 'json'
require 'octokit'
require 'pp'

# Start
# Loop every 5 seconds, check for new message in /queue
# Process (long running)
# Write results to github, then continue looping

QUEUE_GLOB = File.dirname(File.expand_path(__FILE__)) + "/queue/*"

class CiWorker
  def start
    puts "Starting worker - Ctrl-C to exit..."
    while true do
      begin
        sleep 5
        process_payload if payload_exists?
      rescue SignalException => e  # Ctrl-C
        puts "\nEXITING"
        exit
      end
    end
  end

  private

  def access_token
    @access_token ||= `git config --global github.patoken`.chomp
    raise "ERROR no github access token" if @access_token.empty?
    @access_token
  end

  def gh_client
    @client ||= Octokit::Client.new(:access_token => access_token)
  end

  def payload_exists?
    oldest_payload
  end

  def oldest_payload
    Dir[QUEUE_GLOB].sort_by {|f| File.mtime(f)}.first
  end

  def timestamp
    Time.now.strftime("%y-%m-%d %H:%M:%S")
  end

  def base_ctx
    {:context => "hgci-#{ENV['USER']}"}
  end

  def ext_ctx(msg, sha)
    base_ctx.merge({:state => msg, :target_url => target_url(sha)})
  end

  def target_url(sha)
    "http://45.79.82.37:9292/sha/#{sha}"
  end

  def payload_vars
    payload      = JSON.parse(File.read(oldest_payload))
    pull_request = payload['pull_request']
    full_name = pull_request['base']['repo']['full_name']
    sha       = pull_request['head']['sha']
    [full_name, sha]
  end

  def process_payload
    full_name, sha = payload_vars
    File.delete(oldest_payload)
    puts "#{timestamp} | BEG #{full_name}/#{sha}"
    gh_client.create_status(full_name, sha, 'pending', base_ctx)
    system "./run_ci #{sha} > ./history/#{sha}.txt"
    status = $?.exitstatus == 0 ? 'success' : 'error'
    puts "#{timestamp} | END #{full_name}/#{sha}/#{status}"
    gh_client.create_status(full_name, sha, status, ext_ctx(status, sha))
  end
end

