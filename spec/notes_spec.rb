require 'spec_helper'

describe 'Check contact notes sorted correctly' do

  it 'notes should be sorted by creation date, newest first' do
    note_contact_details = ({
      'first_name' => 'Note',
      'last_name' => 'Noteray',
    })

    response = client.post('contacts.json', note_contact_details)
    
    note_contact_id = response['data']['contact']['id']

    note1 = ({ 'date' => "2013-09-08", 'text' => "september 2013 note" })
    note2 = ({ 'date' => "2014-09-08", 'text' => "september 2014 note" })
    note3 = ({ 'date' => "2013-10-08", 'text' => "october 2013 note" })

    client.post("contacts/#{note_contact_id}/notes.json", note1)
    client.post("contacts/#{note_contact_id}/notes.json", note2)
    client.post("contacts/#{note_contact_id}/notes.json", note3)

    response = client.get("contacts/#{note_contact_id}.json?fields=notes(all)")
    notes = response['data']['notes']

    expect(notes[0]['date']).to eq("2014-09-08")
    expect(notes[1]['date']).to eq("2013-10-08")
    expect(notes[2]['date']).to eq("2013-09-08")

    # delete contact
    client.delete("contacts/#{note_contact_id}.json")
   end
end
