require 'spec_helper'

describe package('udhcpd') do
  it { should be_installed }
end

describe service('udhcpd') do
  it { should be_enabled }
  it { should be_running }
end

describe package('hostapd') do
  it { should be_installed }
end

describe service('hostapd') do
  it { should be_enabled }
  it { should be_running }
end

describe port(4567) do
  it { should be_listening }
end
