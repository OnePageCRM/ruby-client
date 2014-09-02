require 'onepageapi'
require 'json_spec'

api_login = 'peter+apitest@xap.ie' # put your login details here
api_pass = 'devteam apitest 5' # put your password here

samples = OnePageAPISamples.new(api_login, api_pass)
samples.login

describe 'Get tags' do
  it 'should not have action_stream_count parameter' do
    response = samples.get('tags.json')
    expect(response['data']['tags'][0].to_json).not_to have_json_path('action_stream_count')
  end

  it 'call with action_stream_count=1 param should return action_stream_count parameter' do
    response = samples.get('tags.json?action_stream_count=1')
    expect(response['data']['tags'][0].to_json).to have_json_path('action_stream_count')
  end

  it 'call with action_stream_count=true param should return action_stream_count parameter' do
    response = samples.get('tags.json?action_stream_count=true')
    expect(response['data']['tags'][0].to_json).to have_json_path('action_stream_count')
  end
end