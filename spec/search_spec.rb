require 'onepageapi'
require 'json_spec'

samples = OnePageAPI.new
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
      'tags' => ['a', 'b']
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
      'starred' => true,
      'tags' => ['b', 'c']
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

  it 'should find one starred contact' do
    response = samples.get('contacts.json?starred=TRUE')
    expect(response['data']['contacts'].count).to be 1
    response = samples.get('contacts.json?starred=true')
    expect(response['data']['contacts'].count).to be 1
    response = samples.get('contacts.json?starred=1')
    expect(response['data']['contacts'].count).to be 1
  end

  it 'should find contacts with matching tags' do
    response = samples.get('contacts.json?tag=a')
    expect(response['data']['contacts'][0]['contact']['id']).to eq @new_contact_id_2.to_s
    response = samples.get('contacts.json?tag=b')
    expect(response['data']['contacts'].count).to be 2
    response = samples.get('contacts.json?tag=c')
    expect(response['data']['contacts'][0]['contact']['id']).to eq @new_contact_id_3.to_s
  end

  it 'should find contacts with actions' do
    response = samples.get('contacts.json?has_actions=true')
    expect(response['data']['contacts'].count).to be 0
    response = samples.post('actions.json', { 'assignee_id' => samples.return_uid,
                                             'contact_id' => @new_contact_id_3,
                                             'text' => 'HASACTIONS',
                                             'status' => 'asap' })
    response = samples.get('contacts.json?has_actions=true')
    expect(response['data']['contacts'].count).to be 1
    response = samples.get('contacts.json?has_actions_for_me=true')
    expect(response['data']['contacts'].count).to be 1
  end

end
