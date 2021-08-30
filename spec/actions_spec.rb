require 'spec_helper'

describe 'Test Actions' do

  before(:each) do
    new_contact_details = ({
      'first_name' => 'Action',
      'last_name' => 'Tester',
      'company_name' => 'Action'
    })

    new_contact = client.create_contact(new_contact_details)
    @new_contact_id = new_contact['contact']['id']
  end

  after(:each) do
    client.delete("contacts/#{@new_contact_id}.json")
  end

  action_id = ''
  it 'should create an date action' do
    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => client.return_uid,
                'text' => 'action_text',
                'date' => '2014-06-20',
                'status' => 'date' })

    created_action = client.create_action(@new_contact_id, action)
    action_id = created_action['data']['action']['id']
    expect(created_action['status']).to be 0

    got_action = client.get("actions/#{action_id}.json")['data']['action']
    action.each do |k, v|
      expect(got_action[k]).to eq(action[k])
    end
  end


  it 'should create and update an asap action' do

    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => client.return_uid,
                'text' => 'action_text',
                'status' => 'asap' })

    response = client.post('actions.json', action)

    created_action = response['data']['action']
    action_id = created_action['id']
    expect(response['status']).to be 0

    got_action = client.get("actions/#{action_id}.json")['data']['action']
    action.each do |k, v|
      expect(got_action[k]).to eq(action[k])
    end

    updated_action = ({ 'contact_id' => @new_contact_id,
                        'assignee_id' => client.return_uid,
                        'text' => 'updated text',
                        'status' => 'asap' })

    request = client.put("actions/#{action_id}.json", updated_action )
    expect(request['status']).to be 0
    updated_action.each do |k, _v|
      expect(request['data']['action'][k]).to eq(updated_action[k])
    end

  end

  it 'should create an waiting for  action' do
    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => client.return_uid,
                'text' => 'waitin for action!',
                'status' => 'waiting' })

    created_action = client.create_action(@new_contact_id, action)
    action_id = created_action['data']['action']['id']
    expect(created_action['status']).to be 0

    got_action = client.get("actions/#{action_id}.json")['data']['action']
    action.each do |k, v|
      expect(got_action[k]).to eq(action[k])
    end
  end

 it 'should not close the sales cycle as there is a N/A' do
    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => client.return_uid,
                'text' => 'try to close',
                'status' => 'asap' })
    request = client.post("contacts/#{@new_contact_id}/actions.json", action)

    try_close = client.put("contacts/#{@new_contact_id}/close_sales_cycle.json", 'comment' => 'close' )
    closed_contact = client.get("contacts/#{@new_contact_id}.json")['data']['contact']
    expect(try_close['error_message']).to eq('Cannot close sales cycle for this contact')
    expect(closed_contact['sales_closed_for']).to eq([])

  end

  it 'should complete a next action' do
    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => client.return_uid,
                'text' => 'to be marked as done',
                'status' => 'asap'
              })
    request = client.post("contacts/#{@new_contact_id}/actions.json", action)
    action_id = request['data']['action']['id']
    updated_action = ({ 'done' => true,
                        'partial' => 1 })
    updated_action = client.put("actions/#{action_id}.json", updated_action )
    expect(updated_action['status']).to eq(0)
    expect(updated_action['data']['action']['done_at']).to_not be nil
    request = client.get("contacts/#{@new_contact_id}.json?fields=next_action(all)")
    expect(request['data']['next_action']).to eq({})
  end

  it 'should complete a next action with mark_as_done' do
    action = ({ 'contact_id' => @new_contact_id,
                'assignee_id' => client.return_uid,
                'text' => 'updated text',
                'status' => 'asap'
              })
    request = client.post("contacts/#{@new_contact_id}/actions.json", action)
    action_id = request['data']['action']['id']
    updated_action = client.put("actions/#{action_id}/mark_as_done.json", {'' => nil} )
    expect(updated_action['status']).to eq(0)
    expect(updated_action['data']['action']['done_at']).to_not be nil
    request = client.get("contacts/#{@new_contact_id}.json?fields=next_action(all)")
    expect(request['data']['next_action']).to eq({})

  end

  it 'should close the sales cycle' do
    client.put("contacts/#{@new_contact_id}/close_sales_cycle.json", 'comment' => 'close this')
    closed_contact = client.get("contacts/#{@new_contact_id}.json")['data']['contact']
    expect(closed_contact['sales_closed_for']).to eq([client.return_uid])

  end

  it 'should reopen the sales cycle' do
    client.put("contacts/#{@new_contact_id}/reopen_sales_cycle.json", 'comment' => 'nil' )
    closed_contact = client.get("contacts/#{@new_contact_id}.json")['data']['contact']
    expect(closed_contact['sales_closed_for']).to eq([])

  end

  it 'should fail gracefully with incorrect input' do
    action = { 'contact_id' => nil, 'assignee_id' => nil,
               'text' => '', 'status' => 'FAKE_STATUS' }
    response = client.post('actions.json', action)
    expect(response['status']).to be(400)
    action['contact_id'] = @new_contact_id
    response = client.post('actions.json', action)
    expect(response['error_message']).to match(/validation/)
  end
end
