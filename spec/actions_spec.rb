require 'onepageapi'
require 'json_spec'
# config = YAML.load_file('../secrets.yml')

api_login = 'peter@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here
samples = OnePageAPISamples.new(api_login, api_pass)
samples.login


describe 'Test Actions' do

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
  it 'should create an date action' do
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
  end

  it 'should create and update an asap action' do

    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => samples.return_uid,
                'text' => 'action_text',
                'status' => 'asap' })

    response = samples.post('actions.json', action)

    created_action = response['data']['action']
    action_id = created_action['id']
    expect(response['status']).to be 0

    got_action = samples.get("actions/#{action_id}.json")['data']['action']
    action.each do |k, v|
      expect(got_action[k]).to eq(action[k])
    end

    updated_action = ({ 'contact_id' => @new_contact_id,
                        'assignee_id' => samples.return_uid,
                        'text' => 'updated text',
                        'status' => 'asap' })

    request = samples.put("actions/#{action_id}.json", updated_action )
    expect(request['status']).to be 0
    updated_action.each do |k, _v|
      expect(request['data']['action'][k]).to eq(updated_action[k])
    end

  end



 it 'should not close the sales cycle as there is a N/A' do
    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => samples.return_uid,
                'text' => 'try to close',
                'status' => 'asap' })
    request = samples.post("contacts/#{@new_contact_id}/actions.json", action)

    try_close = samples.put("contacts/#{@new_contact_id}/close_sales_cycle.json", 'comment' => 'close' )
    closed_contact = samples.get("contacts/#{@new_contact_id}.json")['data']['contact']
    expect(try_close['error_message']).to eq('Cannot close sales cycle as you have a Next Action for this contact')
    expect(closed_contact['sales_closed_for']).to eq([])

  end

  it 'should complete a next action' do
    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => samples.return_uid,
                'text' => 'updated text',
                'status' => 'asap'
              })
    request = samples.post("contacts/#{@new_contact_id}/actions.json", action)
    action_id = request['data']['action']['id']
    updated_action = ({ 'done' => true,
                        'partial' => 1 })
    updated_action = samples.put("actions/#{action_id}.json", action )
    expect(updated_action['status']).to eq(0)
  end

  it 'should close the sales cycle' do
    samples.put("contacts/#{@new_contact_id}/close_sales_cycle.json", 'comment' => 'close this')
    closed_contact = samples.get("contacts/#{@new_contact_id}.json")['data']['contact']
    expect(closed_contact['sales_closed_for']).to eq([samples.return_uid])

  end

  it 'should reopen the sales cycle' do
    samples.put("contacts/#{@new_contact_id}/reopen_sales_cycle.json", 'comment' => 'nil' )
    closed_contact = samples.get("contacts/#{@new_contact_id}.json")['data']['contact']
    expect(closed_contact['sales_closed_for']).to eq([])

  end
end
