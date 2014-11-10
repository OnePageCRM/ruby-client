require 'onepageapi'
require 'json_spec'

samples = OnePageAPI.new
samples.login

describe 'Test Action Stream' do

  before(:each) do
    new_contact_details = ({
      'first_name' => 'Action',
      'last_name' => 'Tester',
      'company_name' => 'Action'
    })

    new_contact = samples.create_contact(new_contact_details)
    @new_contact_id = new_contact['contact']['id']
  end

  after(:each) do
    samples.delete("contacts/#{@new_contact_id}.json")
  end
 
  action_id = ''
  it 'date action in action stream should display correctly' do
    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => samples.return_uid,
                'text' => 'action_text',
                'date' => '2014-06-20',
                'status' => 'date' })

    created_action = samples.create_action(@new_contact_id, action)
    action_id = created_action['data']['action']['id']
    expect(created_action['status']).to be 0

    got_action = samples.get("actions/#{action_id}.json")['data']['action']

    expect(got_action['contact_id']).to eq(action['contact_id'])
    expect(got_action['assignee_id']).to eq(action['assignee_id'])
    expect(got_action['text']).to eq(action['text'])
    expect(got_action['date']).to eq(action['date'])
    expect(got_action['status']).to eq(action['status'])

    response = samples.get('action_stream.json')

    contacts = response['data']['contacts']
    contact = contacts.select { |c| c['contact']['id'] == @new_contact_id }[0]
    next_action = contact['next_action']
    expect(next_action['text']).to eq(action['text'])
    expect(next_action['date']).to eq(action['date'])
    expect(next_action['status']).to eq(action['status'])
    expect(next_action['contact_id']).to eq(action['contact_id'])
    expect(next_action['assignee_id']).to eq(action['assignee_id'])
  end

end
