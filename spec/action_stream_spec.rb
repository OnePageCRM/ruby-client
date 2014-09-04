require 'onepageapi'
require 'json_spec'

api_login = 'peter+apitest@xap.ie' # put your login details here
api_pass = 'devteam apitest 5' # put your password here
samples = OnePageAPISamples.new(api_login, api_pass)
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
    action.each do |k, v|
      expect(got_action[k]).to eq(action[k])
    end

    response = samples.get('action_stream.json')
    contacts = response['data']['contacts']
    contact = contacts.first{ |c| c['contact']['id'] == @new_contact_id }
    next_action = contact['next_action']

    action.each do |k, v|
      expect(next_action[k]).to eq(action[k])
    end
  end

end
