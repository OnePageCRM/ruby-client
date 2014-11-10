require 'onepageapi'
require 'json_spec'

samples = OnePageAPI.new
samples.login

describe 'Partially update a contact', :pending => false do
  before(:each) do
     new_contact_details = ({
        'first_name' => 'Update',
        'last_name' => 'Part',
        'company_name' => 'Partial updates',
        'type' => 'company'
      })

    new_contact = samples.create_contact(new_contact_details)
    @new_contact_id = new_contact['contact']['id']
  end

  after(:all) do
    samples.delete("contacts/#{@new_contact_id}.json")
  end

  it 'should partially update the contact last_name' do
    partial_contact_update = ({
      'partial' => 1,
      'last_name' => 'Partially'
    })

    response = samples.put("contacts/#{@new_contact_id}.json",
                           partial_contact_update)

    expect(response['status']).to be 0
    expect(response['data']['contact']['last_name']).to eq partial_contact_update['last_name']
  end

  it 'should set the last name to be blank' do
    partial_contact_update = ({
      'partial' => 1,
      'last_name' => ''
    })

    response = samples.put("contacts/#{@new_contact_id}.json",
                           partial_contact_update)

    expect(response['status']).to be 0
    expect(response['data']['contact']['last_name']).to eq partial_contact_update['last_name']

  end

end
