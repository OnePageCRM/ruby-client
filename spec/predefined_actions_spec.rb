require 'spec_helper'

describe 'Create and update predefined actions' do

  it 'should return predefined actions' do
    response = client.get('predefined_actions.json')
    expect(response['status']).to be 0
    expect(response['data'].to_json).to have_json_path('predefined_actions')
  end

  it 'should add a predefined action' do
    response = client.post('predefined_actions.json', 'text' => 'hello', 'days' => 5)
    expect(response['status']).to be 0
    expect(response['data']['predefined_action']['text']).to eq 'hello'
    expect(response['data']['predefined_action']['days']).to eq 5
  end

  it 'should not add a predefined action because days is negative' do 
    response = client.post('predefined_actions.json', 'text' => 'negative', 'days' => -4)
    expect(response['status']).to be 400
  end

  it 'should not add a predefined action because days doesn\'t exist' do 
    response = client.post('predefined_actions.json', 'text' => 'no days')
    expect(response['status']).to be 400
  end

  it 'should not add a predefined action because text doesn\'t exist' do 
    response = client.post('predefined_actions.json', 'days' => '1')
    expect(response['status']).to be 400
  end

  it 'should update a predefined action' do
    predefined_actions = client.get('predefined_actions.json')['data']['predefined_actions']
    last_id = predefined_actions.last['predefined_action']['id']
    response = client.put("predefined_actions/#{last_id}.json", 'text' => 'goodbye', 'days' => 10)
    expect(response['status']).to be 0
    expect(response['data']['predefined_action']['text']).to eq 'goodbye'
    expect(response['data']['predefined_action']['days']).to eq 10
  end

  it 'should delete the predefined action' do
    predefined_actions = client.get('predefined_actions.json')['data']['predefined_actions']
    last_id = predefined_actions.last['predefined_action']['id']
    response = client.delete("predefined_actions/#{last_id}.json")
    expect(response['status']).to be 0
  end

end
