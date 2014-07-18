require 'onepageapi'
require 'json_spec'

api_login = 'peter@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here

describe 'Create contact', :pending => false do
  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login

  it 'should create a new contact' do
    new_contact_details = ({
      'first_name' => 'yes',
      'last_name' => 'address',
      'company_name' => 'ACMEinc',
      'starred' => false,
      'tags' => %w(api_test1 api_test2),
      'emails' => [{
        'type' => 'work',
        'value' => 'johnny@exammmple.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE',
      'address_list'=> [
        'city'=> 'San Francisco',
        'state'=> 'CA'
      ]
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']
    expect(got_deets['first_name']).to eq(new_contact_details['first_name'])
    
    details_without_address = new_contact_details.reject { |k| k == 'address_list' }

    details_without_address.each do |k, v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end

    # check address
    address = new_contact_details['address_list'][0]
    expect(address['city']).to eq 'San Francisco'
    expect(address['state']).to eq 'CA'
  end

  it 'should create a new contact without an address' do
    details_without_address = ({
      'first_name' => 'yes',
      'last_name' => 'address',
      'company_name' => 'ACMEinc',
      'starred' => false,
      'tags' => %w(api_test1 api_test2),
      'emails' => [{
        'type' => 'work',
        'value' => 'johnny@exammmple.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE'
    })

    new_contact = samples.create_contact(details_without_address)
    new_contact_id = new_contact['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']
    expect(got_deets['first_name']).to eq(details_without_address['first_name'])

    details_without_address.each do |k, v|
      expect(got_deets[k]).to eq(details_without_address[k])
    end


  end

    it 'should not create a new contact because address_list is not formatted correctly' do
    new_contact_details = ({
      'first_name' => 'no',
      'last_name' => 'address',
      'company_name' => 'sss',
      'starred' => false,
      'tags' => %w(api_test1 api_test2),
      'emails' => [{
        'type' => 'work',
        'value' => 'johnny@exammmple.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE',
      'address_list' => {
        'city' => 'San Francisco',
        'state' => 'CA'
      }
    })

    response = samples.post('contacts.json', new_contact_details)
    expect(response['status']).to be 400
  end

end