require '../lib/onepageapi'
require 'faker'

samples = OnePageAPISamples.new
samples.login

10.times do
  new_contact_details = ({
    'first_name' => Faker::Name.first_name,
    'last_name' => Faker::Name.last_name,
    'company_name' => Faker::Company.name,
    'starred' => false,
    'emails' => [{
      'type' => 'work',
      'value' => Faker::Internet.email }],
    'phones' => [{
      'type' => 'work',
      'value' => Faker::PhoneNumber.phone_number }],
    'urls' => [{
      'type' => 'website',
      'value' => Faker::Internet.url('example.com') }],
    'background' => Faker::Lorem.sentence,
    'job_title' => Faker::Lorem.word,
    'address_list' => [
      'city' => Faker::Address.city,
      'state' => Faker::Address.state_abbr
    ]
  })

  samples.post('contacts.json', new_contact_details)

end
