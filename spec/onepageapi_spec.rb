require 'onepageapi'
require 'json_spec'

api_login = 'xxxx' # put your login details here
api_pass = 'xxxx' # put your password here

describe OnePageAPISamples do
  samples = OnePageAPISamples.new(api_url, api_login, api_pass)
  samples.login

  it 'checks samples bootstrap' do
    samples.bootstrap['status'].should be == 0
    samples.bootstrap['data']['user']['user']['email'].should be == api_login
    samples.bootstrap.to_json.should have_json_path('data')
  end

  it 'check action_stream' do
    action_stream = samples.get_action_stream
    expect { action_stream }.to_not raise_error
  end

  it 'check get_contact_details' do
    contact_id = samples.get_contacts_list[0]['contact']['id']
    expect { samples.get_contact_details(contact_id) }.to_not raise_error
  end

  it 'should create a new contact' do
    new_contact_details = ({
      'first_name' => 'Johnny',
      'last_name' => 'Deer',
      'company_name' => 'ACMEinc',
      'starred' => true,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@exammmple.com' }]
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']
    expect(got_deets['first_name']).to eq(new_contact_details['first_name'])

    new_contact_details.each do |k, v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end
  end

  it 'should update a contact' do
    new_contact_details = ({
      'first_name' => 'Johnny',
      'last_name' => 'Deer',
      'company_name' => 'ACMEinc',
      'starred' => true,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@exammmple.com' }]
    })
    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']

    changed_contact_details = ({
      'first_name' => 'John',
      'last_name' => 'Deer',
      'company_name' => 'ACME Inc.',
      'starred' => false,
      'emails' => [{
          'type' => 'work',
          'value' => 'john@example.com' }]
    })
    samples.update_contact(new_contact_id, changed_contact_details)

    updated_deets = samples
                    .get_contact_details(new_contact_id)['data']['contact']
    changed_contact_details.each do |k, v|
      expect(updated_deets[k]).to eq(changed_contact_details[k])
    end

  end

  it 'should delete the new contact' do
    new_contact_details = ({
      'first_name' => 'Johnny',
      'last_name' => 'Deer',
      'company_name' => 'ACMEinc',
      'starred' => true,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@exammmple.com' }]
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']
    expect(got_deets['first_name']).to eq(new_contact_details['first_name'])

    samples.delete_contact(new_contact_id)
    expect(samples.get_contact_details(new_contact_id)['status']).to be 404
  end

  it 'should change auth key' do
    orig_auth_key = samples.bootstrap['data']['auth_key']
    samples.change_auth_key
    new_auth_key = samples.bootstrap['data']['auth_key']
    orig_auth_key.should_not be == new_auth_key
  end

  it 'should log us out' do
    samples.logout['status'].should == 0
  end

end
