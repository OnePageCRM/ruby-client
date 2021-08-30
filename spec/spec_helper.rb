require 'onepageapi'
require 'json_spec'

require 'spec_helper'

def client
  OnePageAPI.new(host: 'http://localhost:3000/api/v3/')
end