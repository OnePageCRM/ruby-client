require 'onepageapi'
require 'json_spec'

samples = OnePageAPI.new
samples.login
describe 'Bootstrap endpoint' do

  response = samples.get('bootstrap.json')
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

describe 'Test bootstrap endpoint with extra parameters', pending: true do
  pending("Not sure if we should do this. Would add a lot of stuff to bootstrap response.
   Will wait until Dimitri asks again.")
  response = samples.get('bootstrap.json?fields=countries')
  json_data = response['data'].to_json

  it 'should have countries parameter in tags path' do
    expect(json_data).to have_json_path 'countries'
  end


end
