require 'onepageapi'
require 'json_spec'

describe 'Create contact and change its type', :pending => false do
  samples = OnePageAPI.new
  samples.login

  it 'should create and update a new contact of company type' do
    new_contact_details = ({
      'first_name' => 'Contact',
      'last_name' => 'Type',
      'company_name' => 'Company or Individual',
      'type' => 'company'
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']
    expect(got_deets['type']).to eq(new_contact_details['type'])

    new_contact_details.each do |k, _v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end

    update_contact_to_individual_type = ({
      'first_name' => 'Individual',
      'last_name' => 'Type',
      'company_name' => 'IndividualType',
      'type' => 'individual',
      'partial' => 1
    })

    response = samples.put("contacts/#{new_contact_id}.json",
                           update_contact_to_individual_type)
    got_deets = response['data']['contact']
    expect(got_deets['type']).to eq(update_contact_to_individual_type['type'])

    new_contact_details.each do |k, _v|
      expect(got_deets[k]).to eq(update_contact_to_individual_type[k])
    end

    update_contact_to_company_type = ({
      'first_name' => 'Company',
      'last_name' => 'Type',
      'company_name' => 'CompanyType',
      'type' => 'company',
      'partial' => 1
    })

    response = samples.put("contacts/#{new_contact_id}.json", update_contact_to_company_type)
    got_deets = response['data']['contact']
    expect(got_deets['type']).to eq(update_contact_to_company_type['type'])

    new_contact_details.each do |k, _v|
      expect(got_deets[k]).to eq(update_contact_to_company_type[k])
    end

    samples.delete("contacts/#{new_contact_id}.json")

  end

end
