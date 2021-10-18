require 'spec_helper'

describe 'delete and undelete contacts' do

  it 'should delete and undo delete of two contacts' do
    initial_num_contacts = client.get('contacts.json')['data']['total_count']
    id_one = client.create_contact({ 'last_name' => 'first contact' })['contact']['id']
    id_two = client.create_contact({ 'last_name' => 'second contact' })['contact']['id']

    expect(client.get('contacts.json')['data']['total_count']).to be initial_num_contacts + 2

    client.delete("contacts/#{id_one}.json")
    client.delete("contacts/#{id_two}.json")

    expect(client.get('contacts.json')['data']['total_count']).to be initial_num_contacts

    client.delete("contacts/#{id_one}.json?undo=1")
    client.delete("contacts/#{id_two}.json?undo=1")

    expect(client.get('contacts.json')['data']['total_count']).to be initial_num_contacts + 2

    # Clean up
    client.delete("contacts/#{id_one}.json")
    client.delete("contacts/#{id_two}.json")
  end
end