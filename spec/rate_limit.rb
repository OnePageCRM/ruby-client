require 'spec_helper'

describe 'Test Action Stream', pending: true do

  it 'it should rate limit if loads of calls', pending: true do

    30.times { client.get('contacts.json') }
    client.get('contacts.json')
    client.get('contacts.json')
    client.get('contacts.json')
    client.get('contacts.json')
    response = client.get('contacts.json')

    puts response

   
  end

end
