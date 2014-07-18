require 'onepageapi'
require 'json_spec'
api_login = 'peter@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here

describe 'Test Actions' do
  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login
  action_id = ''
  ne_contact_details = ({
      'first_name' => 'Action',
      'last_name' => 'Tester',
      'company_name' => 'ACTION',
      'starred' => false
    })
  ne_contact = samples.create_contact(ne_contact_details)
  ne_contact_id = ne_contact['contact']['id']

  it 'should create an date action' do
    action = ({ 'contact_id' => ne_contact_id,
                'assignee_id' => samples.return_uid,
                'text' => 'action_text',
                'date' => '2014-06-20',
                'status' => 'date' })

    created_action = samples.create_action(ne_contact_id, action)
    action_id = created_action['data']['action']['id']
    expect(created_action['status']).to be 0

    got_action = samples.get("actions/#{action_id}.json")['data']['action']
    action.each do |k, v|
      expect(got_action[k]).to eq(action[k])
    end
  end

  it 'should create an asap action' do
    asap_ne_contact_details = ({
      'first_name' => 'ASAP ACTION',
      'last_name' => 'Tester',
      'company_name' => 'ASAP',
      'starred' => false
    })
    asap_ne_contact = samples.create_contact(asap_ne_contact_details)
    asap_ne_contact_id = asap_ne_contact['contact']['id']

    action = ({ 'contact_id' => asap_ne_contact_id,
                'assignee_id' => samples.return_uid,
                'text' => 'action_text',
                'status' => 'asap' })

    created_action = samples.create_action(asap_ne_contact_id, action)
    puts 'created action ###################'
    puts created_action
    action_id = created_action['data']['action']['id']
    expect(created_action['status']).to be 0

    got_action = samples.get("actions/#{action_id}.json")['data']['action']
    action.each do |k, v|
      expect(got_action[k]).to eq(action[k])
    end
  end

  it 'should update an action' do
    action = ({ 'contact_id' => ne_contact_id,
                'assignee_id' => samples.return_uid,
                'text' => 'updated text',
                'status' => 'asap' })
    # puts action
    updated_action = samples.put("actions/#{action_id}.json", action )
    expect(updated_action['status']).to be 0
    got_action = samples.get("actions/#{action_id}.json")['data']['action']
    action.each do |k, v|
      expect(got_action[k]).to eq(action[k])
    end
  end

  it 'should fail to update NA as json is invalid' do 
    action = ({ 'contact_id' => ne_contact_id,
                'assignee_id' => samples.return_uid,
                'text' => 'updated text',
                'status' => 'asap' })
    puts action
  end

 it 'should not close the sales cycle as there is a N/A' do
    try_close = samples.put("contacts/#{ne_contact_id}/close_sales_cycle.json", 'comment' => 'close' )
    closed_contact = samples.get("contacts/#{ne_contact_id}.json")['data']['contact']
    puts closed_contact
    expect(try_close['error_message']).to eq('Cannot close sales cycle as you have a Next Action for this contact')
    expect(closed_contact['sales_closed_for']).to eq([])

  end

  it 'should complete a next action' do
    action = ({ 'contact_id' => ne_contact_id,
                'assignee_id' => samples.return_uid,
                'text' => 'updated text',
                'status' => 'asap',
                'done' => true })
    updated_action = samples.put("actions/#{action_id}.json", action )
    expect(updated_action['status']).to eq(0)
  end

  it 'should close the sales cycle' do
    samples.put("contacts/#{ne_contact_id}/close_sales_cycle.json", 'comment' => 'close this')
    closed_contact = samples.get("contacts/#{ne_contact_id}.json")['data']['contact']
    expect(closed_contact['sales_closed_for']).to eq([samples.return_uid])

  end

  it 'should reopen the sales cycle' do
    samples.put("contacts/#{ne_contact_id}/reopen_sales_cycle.json", 'comment' => 'nil' )
    closed_contact = samples.get("contacts/#{ne_contact_id}.json")['data']['contact']
    expect(closed_contact['sales_closed_for']).to eq([])

  end
end
