require 'onepageapi'
require 'json_spec'

samples = OnePageAPISamples.new
samples.login

describe 'Popular Countries' do
  response = samples.get('popular_countries.json')
  it 'should have popular json path' do
    expect(response['data'].to_json).to have_json_path('popular')
  end
  it 'should have all json path' do
    expect(response['data'].to_json).to have_json_path('all')
  end
end
