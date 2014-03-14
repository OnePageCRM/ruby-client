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