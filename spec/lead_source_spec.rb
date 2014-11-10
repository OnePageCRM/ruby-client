require 'onepageapi'
require 'json_spec'
require 'pry'

samples = OnePageAPI.new
samples.login

number_of_sources = samples.get('lead_sources.json')['data'].count
lead_source_text = rand(36**8).to_s(36)
describe 'Create new lead source' do
  
  it 'should have added a lead source' do
    response = samples.post('lead_sources.json', 'text' => lead_source_text)
    expect(response['status']).to be 0
    expect(response['message']).to eq 'OK'
    expect(response['data']['text']).to eq lead_source_text
    new_no_sources = samples.get('lead_sources.json')['data'].count
    expect(new_no_sources).to be number_of_sources + 1
    number_of_sources = new_no_sources
  end

  it 'should have not added a lead source as no text param' do
    response = samples.post('lead_sources.json', 'name' => 'name' + lead_source_text)
    expect(response['status']).to be 400
    expect(response['message']).to eq 'Invalid request data'
    expect(response['error_name']).to eq 'invalid_request_data'
    expect(response['error_message']).to eq 'A validation error has occurred'
    expect(response['errors']['text']).to eq "Can't create a lead_source text with an empty string"
    new_no_sources = samples.get('lead_sources.json')['data'].count
    expect(new_no_sources).to be number_of_sources
  end
  
end

describe 'Update existing lead source' do
  sources = samples.get('lead_sources.json')['data']
  number_of_sources = sources.count
  last_id = sources.last['id']

  it 'should update the last lead source' do
    new_lead_source_text = 'new_' + lead_source_text
    response = samples.put("lead_sources/#{last_id}.json", 'text' => new_lead_source_text)
    expect(response['status']).to be 0
    expect(response['message']).to eq 'OK'
    expect(response['data']['text']).to eq new_lead_source_text
    new_no_sources = samples.get('lead_sources.json')['data'].count

    expect(new_no_sources).to eq number_of_sources

  end

  it 'should error with wrong lead source id' do
    error_lead_source_text = 'error_' + lead_source_text
    wrong_id = last_id + '1'
    response = samples.put("lead_sources/#{wrong_id}.json", 'text' => error_lead_source_text)
    expect(response['status']).to be 400
    expect(response['message']).to eq 'Invalid request data'
    expect(response['error_name']).to eq 'invalid_request_data'
    expect(response['error_message']).to eq 'A validation error has occurred'
    # response['errors'] should look something like below:
    # {"id"=>
    #  "'53c507c31da4171a760000981' is not valid. Valid options are [\"53c4f0aa1da4171a76000017\", \"53c4f6c71da4171a7600004a\", \"53c4f7181da4171a7600004c\", \"53c4f83a1da4171a7600004e\", \"53c4f8591da4171a76000050\", \"53c4fe671da4171a76000052\", \"53c4ff431da4171a76000054\", \"53c4ff781da4171a76000056\", \"53c4fff61da4171a76000058\", \"53c500191da4171a7600005a\", \"53c506261da4171a7600008b\", \"53c506561da4171a7600008d\", \"53c506721da4171a7600008f\", \"53c506ab1da4171a76000091\", \"53c507c31da4171a76000098\", \"53c507ef1da4171a7600009a\"]"}
    new_no_sources = samples.get('lead_sources.json')['data'].count
    expect(new_no_sources).to eq new_no_sources
  end


end
