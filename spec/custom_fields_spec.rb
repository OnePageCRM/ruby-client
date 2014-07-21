require 'onepageapi'
require 'json_spec'
require 'pry'
api_login = 'peter@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here

describe 'Check custom fields create and update' do
  samples = OnePageAPISamples.new(api_login, api_pass)
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
      ]}

    response = samples.post('custom_fields.json', new_cf)
    expect(response['status']).to be 0
    expect(response['message']).to eq 'Created'
    expect(response['data']['custom_field']['name']).to eq select_box_name
    expect(response['data']['custom_field']['type']).to eq 'select_box'
    expect(response['data']['custom_field']['choices']).to be_kind_of(Array)
    expect(response['data']['custom_field']['choices']).to match_array(['A', 'B', 'C', 'D'])

    new_cf_id = response['data']['custom_field']['id'].to_s
    samples.delete("custom_fields/#{new_cf_id}.json")

  end

  it 'should create a new contact with custom fields' do

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
    puts response
    cf_id = response['data']['custom_field']['id']

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
        'id' => cf_id,
        'value' => 'B'
      ]
    })

    new_contact = samples.create_contact(new_contact_details)
    puts new_contact
    new_contact_id = new_contact['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']

    details_without_cfs = new_contact_details.reject { |k| k == 'custom_fields' }

    details_without_cfs.each do |k, v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end

    custom_fields = got_deets['custom_fields']
    expect(custom_fields[0]['value']).to eq 'B'
    expect(custom_fields[0]['custom_field']['id']).to eq cf_id

  end

end