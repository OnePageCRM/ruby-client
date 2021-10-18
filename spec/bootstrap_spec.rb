require 'spec_helper'

describe 'Bootstrap endpoint' do

  response = client.get('bootstrap.json')
  json_data = response.to_json
  
  it 'should contain default_contact_type param' do
    contact_type = response['data']['settings']['default_contact_type']
    if contact_type == 'company' || contact_type == 'individual'
      @pass = true
    end
    expect(@pass).to be true
  end

  it 'should have json path data/settings/popular_countries popular countries path' do
    expect(json_data).to have_json_path 'data/settings/popular_countries'
  end

  it 'should have counts parameter in statuses path' do
    expect(json_data).to have_json_path 'statuses/0/status/counts'
  end
  it 'should have total_count parameter in statuses path' do
    expect(json_data).to have_json_path 'statuses/0/status/total_count'
  end
  it 'should have action_stream_count parameter in statuses path' do
    expect(json_data).to have_json_path 'statuses/0/status/action_stream_count'
  end

  it 'should have counts parameter in tags path' do
    expect(json_data).to have_json_path 'tags/tags/0/counts'
  end
  it 'should have total_count parameter in tags path' do
    expect(json_data).to have_json_path 'tags/tags/0/total_count'
  end
  it 'should have action_stream_count parameter in tags path' do
    expect(json_data).to have_json_path 'tags/tags/0/action_stream_count'
  end
end
