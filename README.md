# OnePageCRM Ruby API Client

This is a short ruby script to help you get started with the OnePageCRM API.

It only contains a small subsection of calls and functions available using the API.

## Getting started

- Clone the repository and cd into the directory

- copy the config/config_sample.yml file to config/config.yml and add your OnePageCRM `user_id` and `api_key`.

- Start `irb` and require the lib/onpageapi file
    > require './lib/onepageapi'

- Create a new client object
    > client = OnePageAPI.new()

- Run the different commands - for example:
    > client.get('bootstrap.json')

    > client.get('contacts.json')

    > client.post('contacts.json', contact_data)

    > client.put('contacts/#{contact_id}.json', updated_contact_data)

## Learn more
For full set of documentation on all endpoints, please visit [https://developer.onepagecrm.com/api/](https://developer.onepagecrm.com/api/)