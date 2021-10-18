require 'spec_helper'

number_of_sources = client.get('lead_sources.json')['data'].count
lead_source_text = rand(36**8).to_s(36)
describe 'Create new lead source' do
  
  it 'should have added a lead source' do
    response = client.post('lead_sources.json', 'text' => lead_source_text)
    expect(response['status']).to be 0
    expect(response['message']).to eq 'Created'
    expect(response['data']['text']).to eq lead_source_text
    new_no_sources = client.get('lead_sources.json')['data'].count
    expect(new_no_sources).to be number_of_sources + 1
    number_of_sources = new_no_sources
  end

  it 'should have not added a lead source as no text param' do
    response = client.post('lead_sources.json', 'name' => 'name' + lead_source_text)
    expect(response['status']).to be 400
    expect(response['message']).to eq 'Incomplete request data'
    expect(response['error_name']).to eq 'incomplete_request_data'
    expect(response['error_message']).to eq 'Required parameter text has not been found or it has invalid format'
    new_no_sources = client.get('lead_sources.json')['data'].count
    expect(new_no_sources).to be number_of_sources
  end
  
end

describe 'Update existing lead source' do
  sources = client.get('lead_sources.json')['data']
  number_of_sources = sources.count
  last_id = sources.last['id']

  it 'should update the last lead source' do
    new_lead_source_text = 'new_' + lead_source_text
    response = client.put("lead_sources/#{last_id}.json", 'text' => new_lead_source_text)
    expect(response['status']).to be 0
    expect(response['message']).to eq 'OK'
    expect(response['data']['text']).to eq new_lead_source_text
    new_no_sources = client.get('lead_sources.json')['data'].count

    expect(new_no_sources).to eq number_of_sources

  end

  it 'should error with wrong lead source id' do
    error_lead_source_text = 'error_' + lead_source_text
    wrong_id = last_id + '1'
    response = client.put("lead_sources/#{wrong_id}.json", 'text' => error_lead_source_text)
    expect(response['status']).to be 404
    expect(response['message']).to eq 'Resource not found'
    expect(response['error_name']).to eq 'resource_not_found'

    new_no_sources = client.get('lead_sources.json')['data'].count
    expect(new_no_sources).to eq new_no_sources
  end


end
