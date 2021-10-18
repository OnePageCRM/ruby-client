#!/usr/bin/env ruby
# require 'rubygems'
require 'net/http'
require 'openssl'
require 'base64'
require 'json'
require 'yaml'
require 'pry'
require 'uri'

CONFIG_FILE = YAML.load_file("#{File.dirname(__FILE__)}/../config/config.yml")

class OnePageAPI
  def initialize(user_id = nil, api_key = nil, host: nil)
    host ||= CONFIG_FILE['host']
    scheme = URI.parse(host).scheme
    if scheme == 'https'
      @use_ssl = true
    else
      @use_ssl = false
    end
    user_id ||= CONFIG_FILE['user_id']
    api_key ||= CONFIG_FILE['api_key']
    @host = host
    @user_id = user_id
    @api_key = api_key
  end

  def return_uid
    @user_id
  end

  def bootstrap
    get('bootstrap.json')
  end

  # Change API key
  def change_auth_key
    @api_key =  Base64::decode64(get('change_auth_key.json')['data']['auth_key'])
  end

  # Get action stream
  def get_action_stream
    get('action_stream.json')['data']['contacts']
  end

  # Get contacts list
  def get_contacts_list
    get('contacts.json')['data']['contacts']
  end

  # Get single contact data
  def get_contact_details(id)
    get("contacts/#{id}.json")
  end

  # Create new contact
  def create_contact(contact_data)
    post('contacts.json', contact_data)['data']
  end

  # Update contact data
  def update_contact(id, contact_data)
    put("contacts/#{id}.json", contact_data)['data']
  end

  # Delete contact
  def delete_contact(id)
    delete("contacts/#{id}.json")
  end

  def create_action(id, action_data)
    post("contacts/#{id}/actions.json", action_data)
  end


  def get_statuses
    get('statuses.json')
  end

  # Send GET request
  def get(endpoint, params = {})
    url = URI.parse(@host + endpoint)
    req = Net::HTTP::Get.new(url.request_uri)
    req.basic_auth @user_id, @api_key

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = @use_ssl
    result = http.request(req).body
    JSON.parse result
  end

  # Send POST request
  def post(endpoint, params = {})
    url = URI.parse(@host + endpoint)
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth @user_id, @api_key
    req.body = params.to_json
    req.add_field('Content-Type', 'application/json; charset=utf-8')

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = @use_ssl
    result = http.request(req).body
    JSON.parse result
  end

  # Send PUT request
  def put(endpoint, params = {})
    url = URI.parse(@host + endpoint)
    req = Net::HTTP::Put.new(url.path)
    req.basic_auth @user_id, @api_key
    req.body = params.to_json
    req.add_field('Content-Type', 'application/json; charset=utf-8')

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = @use_ssl
    result = http.request(req).body
    JSON.parse result
  end

  # Send DELETE request
  def delete(endpoint, params = {})
    url = URI.parse(@host + endpoint)
    req = Net::HTTP::Delete.new(url.request_uri)
    req.basic_auth @user_id, @api_key

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = @use_ssl
    result = http.request(req).body
    JSON.parse result
  end
end
