require 'onepageapi'
require 'json_spec'

api_login = 'peter+apitest@xap.ie' # put your login details here
api_pass = 'devteam apitest 5' # put your password here

describe 'Create contact' do
  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login

  it 'should create a new contact' do
    new_contact_details = ({
      'first_name' => 'yes',
      'last_name' => 'address',
      'company_name' => 'ACME&inc',
      'starred' => false,
      'tags' => %w(api_test1 api_test2),
      'emails' => [{
        'type' => 'work',
        'value' => 'johnny@exammmple.com' }],
      'phones' => [{
        'type' => 'work',
        'value' => '00033353' }],
      'urls' => [{
        'type' => 'website',
        'value' => 'lsdkiteboarding.com' }],
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
    address = got_deets['address_list'][0]
    expect(address['city']).to eq 'San Francisco'
    expect(address['state']).to eq 'CA'

    # delete contact
    samples.delete("contacts/#{new_contact_id}.json")
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

    # delete contact
    samples.delete("contacts/#{new_contact_id}.json")
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


  it 'should create and update a new contact with full address' do
    new_contact_details = ({
      'first_name' => 'yes',
      'last_name' => 'address',
      'company_name' => 'ACMEinc',
      'starred' => false,
      'tags' => %w(api_test1 api_test2),
      'emails' => [{
        'type' => 'work',
        'value' => 'johnny@exammmple.com' }],
      'phones' => [{
        'type' => 'work',
        'value' => '00033353' }],
      'urls' => [{
        'type' => 'website',
        'value' => 'lsdkiteboarding.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE',
      'address_list'=> [
        'address' => 'Address',
        'city' => 'City',
        'state' => 'State',
        'zip_code' => 'Zip',
        'country_code' => 'AO'
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
    address = got_deets['address_list'][0]
    expect(address['address']).to eq 'Address'
    expect(address['city']).to eq 'City'
    expect(address['state']).to eq 'State'
    expect(address['zip_code']).to eq 'Zip'
    expect(address['country_code']).to eq 'AO'

    # Update address

    updated_contact_details = ({
      'partial' => true,
      'address_list'=> [
        'address' => 'UPDATED Address',
        'city' => 'UPDATED City',
        'state' => 'UPDATED State',
        'zip_code' => 'UPDATED Zip',
        'country_code' => 'AE'
      ]
    })

    updated_contact = samples.put("contacts/#{new_contact_id}.json", updated_contact_details)
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']
    expect(got_deets['first_name']).to eq(new_contact_details['first_name'])
    
    details_without_address = new_contact_details.reject { |k| k == 'address_list' }

    details_without_address.each do |k, v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end

    # check address
    address = got_deets['address_list'][0]
    expect(address['address']).to eq 'UPDATED Address'
    expect(address['city']).to eq 'UPDATED City'
    expect(address['state']).to eq 'UPDATED State'
    expect(address['zip_code']).to eq 'UPDATED Zip'
    expect(address['country_code']).to eq 'AE'

    # delete contact
    samples.delete("contacts/#{new_contact_id}.json")
  end

end