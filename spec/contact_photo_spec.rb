require 'onepageapi'
require 'json_spec'

api_login = 'peter+apitest@xap.ie' # put your login details here
api_pass = 'devteam apitest 5' # put your password here
samples = OnePageAPISamples.new(api_login, api_pass)
samples.login

describe 'Contact Photo' do

  it 'should upload the photo url' do

  end

end