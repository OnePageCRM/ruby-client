require 'onepageapi'
require 'json_spec'

api_login = 'peter+apitest@xap.ie' # put your login details here
api_pass = 'devteam apitest 5' # put your password here
samples = OnePageAPISamples.new(api_login, api_pass)
samples.login

describe 'Test Actions' do

  before(:each) do
    new_contact_details_1 = ({
      'first_name' => 'Search',
      'last_name' => '1',
      'company_name' => 'Action',
      'emails' => [{
        'type' => 'work',
        'value' => 'search1@email.com' }],
      'phones' => [{
        'type' => 'work',
        'value' => '00033353' }],
      'urls' => [{
        'type' => 'website',
        'value' => 'lsdkiteboarding.com' }],
    })

    new_contact = samples.create_contact(new_contact_details_1)
    @new_contact_id_1 = new_contact['contact']['id']

    new_contact_details_2 = ({
      'first_name' => 'Search',
      'last_name' => '2',
      'company_name' => 'Action',
      'emails' => [{
        'type' => 'work',
        'value' => 'search2@email.com' }],
      'phones' => [{
        'type' => 'work',
        'value' => '00033353' }],
      'urls' => [{
        'type' => 'website',
        'value' => 'rossespointguesthouse.com' }],
    })

    new_contact = samples.create_contact(new_contact_details_2)
    @new_contact_id_2 = new_contact['contact']['id']

    new_contact_details_3 = ({
      'first_name' => 'Search',
      'last_name' => '3',
      'company_name' => 'Action',
      'emails' => [{
        'type' => 'work',
        'value' => 'search3@email.com' }],
      'phones' => [{
        'type' => 'work',
        'value' => '00033353' }],
      'urls' => [{
        'type' => 'website',
        'value' => 'rossespointguesthouse.com' }],
    })

    new_contact = samples.create_contact(new_contact_details_3)
    @new_contact_id_3 = new_contact['contact']['id']
  end

  after(:each) do
    samples.delete("contacts/#{@new_contact_id_1}.json")
    samples.delete("contacts/#{@new_contact_id_2}.json")
    samples.delete("contacts/#{@new_contact_id_3}.json")
  end

  it 'should find three contacts with string Search in it' do
    response = samples.get('contacts.json?search=search')
    expect(response['data']['contacts'].count).to be 3
  end

  it 'should find one contact with email address search2@email.com' do
    response = samples.get('contacts.json?email=search2@email.com')
    expect(response['data']['contacts'].count).to be 1
  end

  it 'should find two contacts with website rossespointguesthouse.com' do
    response = samples.get('contacts.json?url=rossespointguesthouse.com')
    expect(response['data']['contacts'].count).to be 2
  end

end