require 'onepageapi'
require 'json_spec'

samples = OnePageAPI.new
samples.login

describe 'Test Action Stream', pending: true do

  it 'it should rate limit if loads of calls', pending: true do

    30.times { samples.get('contacts.json') }
    samples.get('contacts.json')
    samples.get('contacts.json')
    samples.get('contacts.json')
    samples.get('contacts.json')
    response = samples.get('contacts.json')

    puts response

   
  end

end
