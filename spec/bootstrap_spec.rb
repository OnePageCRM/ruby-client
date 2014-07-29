require 'onepageapi'
require 'json_spec'

api_login = 'peter@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here

describe 'Bootstrap endpoint' do

  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login
  it 'should contain default_contact_type param' do
    response = samples.get('bootstrap.json')
    
    contact_type = response['data']['settings']['default_contact_type']
    if contact_type == 'company' || contact_type == 'individual'
      @pass = true
    end
    expect(@pass).to be true
  end

end