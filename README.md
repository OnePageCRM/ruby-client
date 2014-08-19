# OnePageCRM Ruby API Client

This is a short ruby script to help you get started with the OnePageCRM API v3.
It only contains a small subsection of calls and functions available using the API.

## Getting started

- Clone the repository and cd into the directory

- Start irb and require the lib/onpageapi file
    $ irb
    > require './lib/onepageapi'

- set your api_login and apt_password
    > api_login = 'you@example.com'
    > api_pass = 'youronpagepassword'

- Create a new samples object and login
    > samples = OnePageAPISamples.new(api_login, api_pass)
    > samples.login

- Run the different commands - for example:
    > samples.bootstrap
    > samples.get_contacts

## Rspec
To run the rspec tests:

- change the username and password in each spec file from `peter@xap.ie` and `password` to your account
- change the @url variable to your local machine if you are testing locally
- run `rspec` to run all the tests
- run `rspec spec/actions_spec.rb` to just run the `actions` test 