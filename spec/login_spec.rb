require 'onepageapi'
require 'json_spec'

samples = OnePageAPI.new

describe 'Test login' do

  it 'should login and add lead_clipper to apps list' do
    params = {
        login: 'peter@xap.ie',
        password: 'p3t3r3t3p'
      }

      auth_data = samples.post('login.json', params)
      @uid = auth_data['data']['user_id']

      @api_key = Base64::decode64(auth_data['data']['auth_key'])
  end
end