require 'onepageapi'
require 'json_spec'
require 'pry'

api_login = 'peter@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here

samples = OnePageAPISamples.new(api_login, api_pass)
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
  end

  it 'should have not added a status as no text param' do
    number_of_statuses = samples.get('statuses.json')['data'].count
    response = samples.post('statuses.json', 'name' => 'name' + status_text)
    expect(response['status']).to be 400
    # expect(response['message']).to eq 'Invalid request data'
    # expect(response['error_name']).to eq 'invalid_request_data'
    # expect(response['error_message']).to eq 'A validation error has occurred'
    # expect(response['errors']['text']).to eq "Can't create a status text with an empty string"
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
    # response['errors'] should look something like below:
    # {"id"=>
    #  "'53c507c31da4171a760000981' is not valid. Valid options are [\"53c4f0aa1da4171a76000017\", \"53c4f6c71da4171a7600004a\", \"53c4f7181da4171a7600004c\", \"53c4f83a1da4171a7600004e\", \"53c4f8591da4171a76000050\", \"53c4fe671da4171a76000052\", \"53c4ff431da4171a76000054\", \"53c4ff781da4171a76000056\", \"53c4fff61da4171a76000058\", \"53c500191da4171a7600005a\", \"53c506261da4171a7600008b\", \"53c506561da4171a7600008d\", \"53c506721da4171a7600008f\", \"53c506ab1da4171a76000091\", \"53c507c31da4171a76000098\", \"53c507ef1da4171a7600009a\"]"}
    new_number_of_statuses = samples.get('statuses.json')['data'].count
    expect(new_number_of_statuses).to eq number_of_statuses
  end

  
end
