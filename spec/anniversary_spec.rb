require 'onepageapi'
require 'json_spec'
require 'pry'

describe 'Check custom fields create and update #' do
  samples = OnePageAPI.new
  samples.login

  it 'custom_fields.json should return correct reminder_days for anniversary fields' do
    anniversary = 'anniversary_' + rand(36**8).to_s(36)
    new_cf = { 'name' => anniversary,
               'type' => 'anniversary',
               'reminder_days' => 2 }
    response = samples.post('custom_fields.json', new_cf)
    cf_id = response['data']['custom_field']['id']
    expect(response['data']['custom_field']['reminder_days']).to be 2
    response = samples.get('custom_fields.json')
    cfs = response['data']['custom_fields']
    anniversary_cf = cfs.select { |cf| cf['custom_field']['id'] == cf_id }[0]
    expect(anniversary_cf['custom_field']['reminder_days']).to be 2

    samples.delete("custom_fields/#{cf_id}.json")

  end


  it 'should create and update new contact with anniversary field the documented way' do

    anniversary = 'anniversary_' + rand(36**8).to_s(36)
    new_cf = { 'name' => anniversary,
               'type' => 'anniversary',
               'reminder_days' => 2 }
    response = samples.post('custom_fields.json', new_cf)
    cf_id = response['data']['custom_field']['id']
    expect(response['data']['custom_field']['reminder_days']).to be 2

    new_contact_details = ({
      'first_name' => 'Anniversary',
      'last_name' => 'Contact',
      'custom_fields' => [
        {
          'custom_field' => {
          'id' => cf_id
        },
          'value' => '2014-02-06'
        }
      ]
    })

    response = samples.post('contacts.json', new_contact_details)
    new_contact = response['data']['contact']
    new_contact_id = new_contact['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']

    details_without_cfs = new_contact_details.reject { |k| k == 'custom_fields' }

    details_without_cfs.each do |k, v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end

    custom_fields = got_deets['custom_fields']
    expect(custom_fields[0]['value']).to eq '2014-02-06'
    expect(custom_fields[0]['custom_field']['id']).to eq cf_id

    samples.delete("contacts/#{new_contact_id}.json")

    samples.delete("custom_fields/#{cf_id}.json")
    samples.delete("contact/#{new_contact_id}.json")
  end


  it 'should create and update new contact with anniversary fields the undocumented way' do

    anniversary = 'anniversary_' + rand(36**8).to_s(36)
    new_cf = { 'name' => anniversary,
               'type' => 'anniversary',
               'reminder_days' => 2 }
    response = samples.post('custom_fields.json', new_cf)
    cf_id = response['data']['custom_field']['id']
    expect(response['data']['custom_field']['reminder_days']).to be 2


    new_contact_details = ({
      'first_name' => 'Anniversary',
      'last_name' => 'Contact',
      'custom_fields' => [
        {
          'id' => cf_id,
          'value' => '2014-02-06'
        }
      ]
    })

    response = samples.post('contacts.json', new_contact_details)
    new_contact_id = response['data']['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']

    details_without_cfs = new_contact_details.reject { |k| k == 'custom_fields' }

    details_without_cfs.each do |k, v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end

    custom_fields = got_deets['custom_fields']
    expect(custom_fields[0]['value']).to eq '2014-02-06'
    expect(custom_fields[0]['custom_field']['id']).to eq cf_id


    samples.delete("contacts/#{new_contact_id}.json")

    samples.delete("custom_fields/#{cf_id}.json")
    samples.delete("contact/#{new_contact_id}.json")
  end

  end
