require 'spec_helper'

describe 'Update Company Name' do

  company_name = rand(36**8).to_s(36)

  new_contact_details = ({
    'first_name' => 'Johnny',
    'last_name' => 'Deer',
    'company_name' => company_name
  })
  second_new_contact_details = ({
    'first_name' => 'Johnny',
    'last_name' => 'Deer',
    'company_name' => company_name
  })

  new_contact = client.create_contact(new_contact_details)
  new_contact_id = new_contact['contact']['id']

  second_new_contact = client.create_contact(second_new_contact_details)
  second_new_contact_id = second_new_contact['contact']['id']


  company_id = client.get_contact_details(new_contact_id)['data']['contact']['company_id']

  it 'should have updated the company name' do
    # update company name
    response = client.put("companies/#{company_id}.json", 'name' => 'NEW_' + company_name)
    new_company_name = client.get_contact_details(new_contact_id)['data']['contact']['company_name']
    second_new_company_name = client.get_contact_details(second_new_contact_id)['data']['contact']['company_name']
    expect(new_company_name).to eq('NEW_' + company_name)
    expect(second_new_company_name).to eq('NEW_' + company_name)
  end

  it 'should not change the company name if no name parameter' do
    # update company name
    response = client.put("companies/#{company_id}.json", 'wrong_name' => 'WRONG_' + company_name)
    new_company_name = client.get_contact_details(new_contact_id)['data']['contact']['company_name']
    second_new_company_name = client.get_contact_details(second_new_contact_id)['data']['contact']['company_name']

    expect(response['status']).to be 400
    # expect(response['message']).to eq 'Invalid request data'
    # expect(response['error_name']).to eq 'invalid_request_data'
    # expect(response['error_message']).to eq 'A validation error has occurred'
    # expect(response['errors']['name']).to eq 'A new company name is needed to update the company'
    expect(new_company_name).to eq('NEW_' + company_name)
    expect(second_new_company_name).to eq('NEW_' + company_name)

  end

  it 'should return if the company_id is wrong' do
    # update company name
    response = client.put("companies/00445.json", 'name' => 'WRONG_CID_' + company_name)
    new_company_name = client.get_contact_details(new_contact_id)['data']['contact']['company_name']
    second_new_company_name = client.get_contact_details(second_new_contact_id)['data']['contact']['company_name']

    expect(new_company_name).to eq('NEW_' + company_name)
    expect(second_new_company_name).to eq('NEW_' + company_name)

  end


end
