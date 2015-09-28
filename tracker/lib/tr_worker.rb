#!/usr/bin/env ruby

require 'yaml'

# Loop every 1 minute, check for new message in /queue
# Process (long running)

class TrWorker

  BASE_DIR       = File.dirname("#{File.expand_path(__FILE__)}../")
  DATA_DIR       = BASE_DIR + "/data"
  HOST_STORE     = DATA_DIR + "/hosts.yml"
  ALERT_SETTINGS = DATA_DIR + "/alert_settings.yml"

  def start
    puts "Starting worker - Ctrl-C to exit..."
    while true do
      begin
        send_alert if alert_condition_exists?
        sleep 60
      rescue SignalException => e
        puts "\nEXITING"
        exit
      end
    end
  end

  private

  def alert_settings
    return {} unless File.exists?(ALERT_SETTINGS)
    YAML.load_file(ALERT_SETTINGS)
  end

  def alert_history
    return {} unless File.exists?(ALERT_HISTORY)
    YAML.load_file(ALERT_HISTORY)
  end

  def alert_condition_exists?
    oldest_payload
  end

  def send_alert
    puts "SENDING ALERT!!"
  end
end

