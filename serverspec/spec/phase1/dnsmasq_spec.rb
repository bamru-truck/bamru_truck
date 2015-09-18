require 'spec_helper'

describe "DnsMasq" do
describe package('dnsmasq') do
  it { should be_installed }
end

describe service('dnsmasq') do
  it { should be_enabled }
  it { should be_running }
end

describe port(53) do
  it { should be_listening }
end

# bootp/dhcp
describe port(67) do
  it { should be_listening }
end
end

