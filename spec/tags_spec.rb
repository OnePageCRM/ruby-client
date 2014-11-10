require 'onepageapi'
require 'json_spec'

samples = OnePageAPI.new
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

  it 'should create a new tag with tags.json endpoint' do
    new_tag_name = rand(36**8).to_s(36)
    response = samples.post('tags.json', 'name' => new_tag_name)
    expect(response['data']['name']).to eq new_tag_name
  end
end
