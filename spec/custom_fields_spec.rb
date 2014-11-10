require 'onepageapi'
require 'json_spec'
require 'pry'

describe 'Check custom fields create and update' do
  samples = OnePageAPI.new
  samples.login

  it 'should get the list of custom fields' do 
    custom_fields = samples.get('custom_fields.json')
    expect(custom_fields['status']).to eq 0

  end

  it 'should create a new select box custom field' do
    select_box_name = 'Select box field'
    new_cf = {
      'name' => select_box_name,
      'type' => 'select_box',
      'choices' => [
        'A',
        'B',
        'C',
        'D'
      ],
      'reminder_days' => 5
    }

    response = samples.post('custom_fields.json', new_cf)
    expect(response['status']).to be 0
    expect(response['message']).to eq 'Created'
    expect(response['data']['custom_field']['name']).to eq select_box_name
    expect(response['data']['custom_field']['type']).to eq 'select_box'
    expect(response['data']['custom_field']['choices']).to be_kind_of(Array)
    expect(response['data']['custom_field']['choices']).to match_array(['A', 'B', 'C', 'D'])
    expect(response['data']['custom_field']['reminder_days']).to be nil
    new_cf_id = response['data']['custom_field']['id'].to_s
    samples.delete("custom_fields/#{new_cf_id}.json")

  end

  it 'should create and update new contact with custom fields the documented way' do

    select_box_name = rand(36**8).to_s(36)
    new_cf = {
      'name' => select_box_name,
      'type' => 'select_box',
      'choices' => [
        'A',
        'B',
        'C',
        'D'
      ]}
    response = samples.post('custom_fields.json', new_cf)
    cf_id = response['data']['custom_field']['id']

    second_select_box_name = rand(36**8).to_s(36)
    second_new_cf = {
      'name' => second_select_box_name,
      'type' => 'select_box',
      'choices' => [
        'X',
        'Y',
        'Z'
      ]}

    response = samples.post('custom_fields.json', second_new_cf)
    second_cf_id = response['data']['custom_field']['id']

    new_contact_details = ({
      'first_name' => 'Johnny',
      'last_name' => 'Deer',
      'company_name' => 'ACMEinc',
      'starred' => false,
      'tags' => %w(api_test1 api_test2),
      'emails' => [{
        'type' => 'work',
        'value' => 'johnny@exammmple.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE',
      'custom_fields' => [
        {
          'custom_field' => {
          'id' => cf_id
        },
          'value' => 'B'
        },
        {
          'custom_field' => {
            'id' => second_cf_id
          },
          'value' => 'Y'
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
    expect(custom_fields[0]['value']).to eq 'B'
    expect(custom_fields[0]['custom_field']['id']).to eq cf_id

    samples.delete("contacts/#{new_contact_id}.json")

    samples.delete("custom_fields/#{cf_id}.json")
    samples.delete("custom_fields/#{second_cf_id}.json")
  end


  it 'should create and update new contact with custom fields the undocumented way' do

    select_box_name = rand(36**8).to_s(36)
    new_cf = {
      'name' => select_box_name,
      'type' => 'select_box',
      'choices' => [
        'A',
        'B',
        'C',
        'D'
      ]}
    response = samples.post('custom_fields.json', new_cf)
    cf_id = response['data']['custom_field']['id']

    second_select_box_name = rand(36**8).to_s(36)
    second_new_cf = {
      'name' => second_select_box_name,
      'type' => 'select_box',
      'choices' => [
        'X',
        'Y',
        'Z'
      ]}

    response = samples.post('custom_fields.json', second_new_cf)
    second_cf_id = response['data']['custom_field']['id']

    new_contact_details = ({
      'first_name' => 'Johnny',
      'last_name' => 'Deer',
      'company_name' => 'ACMEinc',
      'starred' => false,
      'tags' => %w(api_test1 api_test2),
      'emails' => [{
        'type' => 'work',
        'value' => 'johnny@exammmple.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE',
      'custom_fields' => [
        {
          'id' => cf_id,
          'value' => 'B'
        },
        {
          'id' => second_cf_id,
          'value' => 'Y'
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
    expect(custom_fields[0]['value']).to eq 'B'
    expect(custom_fields[0]['custom_field']['id']).to eq cf_id

    updated_contact_details = ({
      'partial' => 1,
      'custom_fields' => [
        {
          'id' => cf_id,
          'value' => 'A'
        } ]
      })
    response = samples.put("contacts/#{new_contact_id}.json", updated_contact_details)
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']

    details_without_cfs = new_contact_details.reject { |k| k == 'custom_fields' }

    details_without_cfs.each do |k, v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end

    custom_fields = got_deets['custom_fields']
    expect(custom_fields[0]['value']).to eq 'A'
    expect(custom_fields[0]['custom_field']['id']).to eq cf_id
    expect(custom_fields[1]['value']).to eq 'Y'
    expect(custom_fields[1]['custom_field']['id']).to eq second_cf_id


    samples.delete("contacts/#{new_contact_id}.json")

    samples.delete("custom_fields/#{cf_id}.json")
    samples.delete("custom_fields/#{second_cf_id}.json")
  end


  it 'should get contacts with a certain custom field value' do

    select_box_name = rand(36**8).to_s(36)
    new_cf = {
      'name' => select_box_name,
      'type' => 'select_box',
      'choices' => [
        'A',
        'B',
        'C',
        'D'
      ]}
    response = samples.post('custom_fields.json', new_cf)
    cf_id = response['data']['custom_field']['id']

    B_contact_details = ({
      'first_name' => 'Right',
      'last_name' => 'Custom Field',
      'custom_fields' => [
        {
          'id' => cf_id,
          'value' => 'B'
        }
      ]
    })

    A_contact_details = ({
      'first_name' => 'Wrong',
      'last_name' => 'Custom Field',
      'custom_fields' => [
        {
          'id' => cf_id,
          'value' => 'A'
        }
      ]
    })
    no_contact_details = ({
      'first_name' => 'No',
      'last_name' => 'Custom Field'
    })
    B_id = samples.post('contacts.json', B_contact_details)['data']['contact']['id']
    A_id = samples.post('contacts.json', A_contact_details)['data']['contact']['id']
    no_id = samples.post('contacts.json', no_contact_details)['data']['contact']['id']

    # call
    response = samples.get("contacts.json?custom_field_id=#{cf_id}&custom_field_value=B")
    expect(response['data']['contacts'].size).to be 1
    expect(response['data']['contacts'][0]['contact']['first_name']).to eq 'Right'

    samples.delete("contacts/#{B_id}.json")
    samples.delete("contacts/#{A_id}.json")
    samples.delete("contacts/#{no_id}.json")
  end

end
