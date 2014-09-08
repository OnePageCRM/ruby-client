require 'onepageapi'
require 'json_spec'


describe 'Bootstrap endpoint' do

  samples = OnePageAPISamples.new
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
