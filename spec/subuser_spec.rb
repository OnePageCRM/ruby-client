require 'onepageapi'
require 'json_spec'

describe 'Test subuser' do
  sub_login = 'peter+subuser@xap.ie'
  sub_pass = 'p3t3r3t3p'
  samples = OnePageAPISamples.new(sub_login, sub_pass)
  samples.login
  it 'should create a new contact owned by subuser' do
    new_contact_details = ({
      'first_name' => 'API',
      'last_name' => 'SUBUSER',
      'company_name' => 'API',
      'starred' => false,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@subuser.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE'
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']

    owner_id = samples.get_contact_details(new_contact_id)['data']['contact']['owner_id']

    expect(owner_id).to eq(samples.return_uid)

  end

  it 'should create a new contact owned by owner' do

   new_contact_details = ({
      'first_name' => 'API',
      'last_name' => 'OWNER',
      'company_name' => 'API',
      'starred' => false,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@subuser.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE',
      'owner_id' =>'5376256f1da41728a5000003'
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
   
    owner_id = samples.get_contact_details(new_contact_id)['data']['contact']['owner_id']

    expect(owner_id).to eq('5376256f1da41728a5000003')

  end
end