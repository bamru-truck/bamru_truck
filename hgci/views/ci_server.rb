require 'sinatra/base'
require 'json'
require 'pp'

class CiServer < Sinatra::Base

  BASE_DIR  = File.dirname(File.expand_path(__FILE__))
  HIST_GLOB = BASE_DIR + "/history/*"

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
    erb :directory
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
      system "mkdir -p #{BASE_DIR}/queue"
      File.open("#{BASE_DIR}/queue/#{sha}.json", 'w') do |f|
        f.puts @json_pl
      end
    end

    def hist_files
      Dir[HIST_GLOB].sort_by {|f| File.mtime(f)}.reverse  # newest first
    end
  end
end

__END__

@@ layout
<html>
  <%= yield %>
</html>

@@ directory
<table>
  <% @files.each do file %>
    <tr>
      <td><a href="/sha/asdf"><%= file.mdate %></td>
      <td>Hello</td>
    </tr>
  <% end %>
</table>
