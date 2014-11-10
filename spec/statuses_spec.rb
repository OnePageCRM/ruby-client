require 'onepageapi'
require 'json_spec'
require 'pry'

samples = OnePageAPI.new
samples.login

status_text = rand(36**8).to_s(36)
describe 'Create and update status' do
  
  it 'should have added a status' do
    number_of_statuses = samples.get('statuses.json')['data'].count
    status = { 'text' => 'text_' + status_text, 'description' => 'description_' + status_text, 'color' => '666666' }
    response = samples.post('statuses.json', status)
    expect(response['status']).to be 0
    expect(response['message']).to eq 'OK'
    expect(response['data']['status']['text']).to eq 'text_' + status_text
    expect(response['data']['status']['description']).to eq 'description_' + status_text
    expect(response['data']['status']['color']).to eq '666666'

    new_number_of_statuses = samples.get('statuses.json')['data'].count
    expect(new_number_of_statuses).to be number_of_statuses + 1
    samples.delete("statuses/#{response['data']['status']['id']}.json")
  end

  it 'should have not added a status as no text param' do
    number_of_statuses = samples.get('statuses.json')['data'].count
    response = samples.post('statuses.json', 'name' => 'name' + status_text)
    expect(response['status']).to be 400
    expect(response['message']).to eq 'Invalid request data'
    expect(response['error_name']).to eq 'invalid_request_data'
    expect(response['error_message']).to eq 'A validation error has occurred'
    expect(response['errors']['text']).to eq "Can't create a status text with an empty string"
    new_number_of_statuses = samples.get('statuses.json')['data'].count
    expect(new_number_of_statuses).to be number_of_statuses
  end

  it 'should update the last status' do
    statuses = samples.get('statuses.json')['data']
    number_of_statuses = statuses.count
    last_id = statuses.last['status']['id']
    status = { 'text' => 'up_text_' + status_text,
               'description' => 'up_description_' + status_text,
               'color' => 'f96600' }

    response = samples.put("statuses/#{last_id}.json", status)
    expect(response['status']).to be 0
    expect(response['message']).to eq 'OK'
    expect(response['data']['status']['text']).to eq 'up_text_' + status_text
    expect(response['data']['status']['description']).to eq 'up_description_' + status_text
    expect(response['data']['status']['color']).to eq 'f96600'
    new_number_of_statuses = samples.get('statuses.json')['data'].count
    expect(new_number_of_statuses).to eq number_of_statuses
  end

  it 'should not update and error with wrong status id' do
    statuses = samples.get('statuses.json')['data']
    number_of_statuses = statuses.count
    last_id = statuses.last['status']['id']

    error_status_text = 'error_' + status_text
    wrong_id = last_id + '1'
    response = samples.put("statuses/#{wrong_id}.json", 'text' => error_status_text)
    expect(response['status']).to be 400
    expect(response['message']).to eq 'Incomplete request data'
    expect(response['error_name']).to eq 'incomplete_request_data'
    expect(response['error_message']).to eq "Can't get data for a single status without a status id"
    new_number_of_statuses = samples.get('statuses.json')['data'].count
    expect(new_number_of_statuses).to eq number_of_statuses
  end
  
end

describe 'Get statuses' do
  it 'should not have action_stream_count parameter' do
    response = samples.get('statuses.json')
    expect(response['data'][0]['status'].to_json).not_to have_json_path('action_stream_count')
  end

  it 'call with action_stream_count=1 param should return action_stream_count parameter' do
    response = samples.get('statuses.json?action_stream_count=1')
    expect(response['data'][0]['status'].to_json).to have_json_path('action_stream_count')
  end
end
