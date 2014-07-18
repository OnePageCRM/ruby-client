require 'onepageapi'
require 'json_spec'

api_login = 'peter@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here

describe 'Test change auth key and logout' do

  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login
  it 'should change auth key' do
    orig_auth_key = samples.bootstrap['data']['auth_key']
    samples.change_auth_key
    new_auth_key = samples.bootstrap['data']['auth_key']
    expect(orig_auth_key).not_to eq(new_auth_key)
  end

  it 'should log us out' do
    expect(samples.logout['status']).to eq(0)
  end

end