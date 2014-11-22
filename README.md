# OnePageCRM Ruby API Client

This is a short ruby script to help you get started with the OnePageCRM API v3.
It only contains a small subsection of calls and functions available using the API.

## Getting started

- Clone the repository and cd into the directory

- copy the config/config_orig.yml file to config/config.yml and add your OnePageCRM login and password.

- Start irb and require the lib/onpageapi file
    $ irb
    > require './lib/onepageapi'

- Create a new samples object and login
    > samples = OnePageAPI.new(api_login, api_pass)
    > samples.login

- Run the different commands - for example:
    > samples.get('bootstrap.json')
    > samples.get('contacts.json')
    > samples.post('contacts.json', contact_data)
    > samples.put('contacts/#{contact_id}.json', updated_contact_data)