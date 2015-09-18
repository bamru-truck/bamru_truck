require 'spec_helper'

describe "Networking" do
  describe kernel_module('ip_tables') do
    it { should be_loaded }
  end

  describe interface('eth0') do
    it { should exist }
    it { should be_up }
  end

  describe interface('wlan0') do
    it { should exist }
    # it { should be_up }
    it { should have_ipv4_address("192.168.42.1") }
  end

  describe package('hostapd') do
    it { should be_installed }
  end

  describe service('hostapd') do
    it { should be_enabled }
    it { should be_running }
  end


  describe host('google.com') do
    it { should be_resolvable }
    it { should be_reachable }
  end

  if host_has_wlan?
    describe "SSID #{ENV['TARGET_HOST']}" do
      it "should see the SSID" do
        expect(ssid_scan).to include(ENV['TARGET_HOST'])
      end
    end
  end
end
