require 'onepageapi'
require 'json_spec'

api_login = 'peter@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here

describe 'Check custom fields create and update' do
  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login

  it 'should get the list of custom fields' do 
    custom_fields = samples.get('custom_fields.json')
    expect(custom_fields['status']).to eq 0

  end

  it 'should create a new dropdown custom field' do
    

  end


  it 'should create a new contact with custom fields' do
    new_contact_details = ({
      'first_name' => 'Johnny',
      'last_name' => 'Deer',
      'company_name' => 'ACMEinc',
      'starred' => false,
      'tags' => %w(api_test1 api_test2),
      'emails' => [{
        'type' => 'work',
        'value' => 'johnny@exammmple.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE',


    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']
    expect(got_deets['first_name']).to eq(new_contact_details['first_name'])

    new_contact_details.each do |k, v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end
  end

end