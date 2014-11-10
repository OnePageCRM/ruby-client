require 'onepageapi'
require 'json_spec'

describe 'delete and undelete contacts' do
  samples = OnePageAPI.new
  samples.login

  it 'should delete and undo delete of two contacts' do
    initial_num_contacts = samples.get('contacts.json')['data']['total_count']
    id_one = samples.create_contact({ 'last_name' => 'first contact' })['contact']['id']
    id_two = samples.create_contact({ 'last_name' => 'second contact' })['contact']['id']

    expect(samples.get('contacts.json')['data']['total_count']).to be initial_num_contacts + 2

    samples.delete("contacts/#{id_one}.json")
    samples.delete("contacts/#{id_two}.json")

    expect(samples.get('contacts.json')['data']['total_count']).to be initial_num_contacts

    samples.delete("contacts/#{id_one}.json?undo=1")
    samples.delete("contacts/#{id_two}.json?undo=1")

    expect(samples.get('contacts.json')['data']['total_count']).to be initial_num_contacts + 2

    # Clean up
    samples.delete("contacts/#{id_one}.json")
    samples.delete("contacts/#{id_two}.json")
  end
end