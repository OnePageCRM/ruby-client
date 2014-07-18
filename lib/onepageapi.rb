#!/usr/bin/env ruby
# require 'rubygems'
require 'net/http'
require 'openssl'
require 'base64'
require 'json'

class OnePageAPISamples
  def initialize(login, password)
    @url = 'https://app.onepagecrm.com/api/v3/'
    @login = login
    @password = password
  end

  # Login user into API
  def login
    params = {
      login: @login,
      password: @password
    }

    auth_data = post('login.json', params)
    @uid = auth_data['data']['user_id']

    # Returns User ID for reference
    puts 'UID =  ' + @uid
    @api_key = Base64::decode64(auth_data['data']['auth_key'])
  end

  def return_uid
    @uid
  end

  def bootstrap
    get('bootstrap.json')
  end

  # Change API key
  def change_auth_key
    @api_key =  Base64::decode64(get('change_auth_key.json')['data']['auth_key'])
  end

  # Logout
  def logout
    get('logout.json')
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
  def get(method, params = {})
    url = URI.parse(@url + method)
    get_data = params.empty? ? '' : '?' + params.to_a.map {|x| x[0] + '=' +
    URI::escape(x[1], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}.join('&').gsub(/%[0-9A-Fa-f]{2}/) {|x| x.downcase}

    req = Net::HTTP::Get.new(url.path + get_data)
    add_auth_headers(req, 'GET', method, params)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    result = http.request(req).body
    JSON.parse result
  end

  # Send POST request
  def post(method, params = {})
    url = URI.parse(@url + method)
    req = Net::HTTP::Post.new(url.path)
    req.body = params.to_json
    req.add_field('Content-Type', 'application/json; charset=utf-8')
    add_auth_headers(req, 'POST', method, params)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    result = http.request(req).body
    JSON.parse result
  end

  # Send PUT request
  def put(method, params = {})
    url = URI.parse(@url + method)
    req = Net::HTTP::Put.new(url.path)
    req.body = params.to_json
    req.add_field('Content-Type', 'application/json; charset=utf-8')
    add_auth_headers(req, 'PUT', method, params)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    result = http.request(req).body
    JSON.parse result
  end

  # Send DELETE request
  def delete(method, params = {})
    url = URI.parse(@url + method)

    delete_data = params.empty? ? '' : '?' + params.to_a.map {|x| x[0] + '=' +
    URI::escape(x[1], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}.join('&').gsub(/%[0-9A-Fa-f]{2}/) {|x| x.downcase}

    req = Net::HTTP::Delete.new(url.path + delete_data)
    add_auth_headers(req, 'DELETE', method, params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    result = http.request(req).body
    JSON.parse result

  end

   # Add authentication headers
  def add_auth_headers(req, http_method, api_method, params)
    return if @uid.nil? || @api_key.nil?

    url_to_sign = @url + api_method
    params_to_sign = params.empty? ? nil : URI.encode_www_form(params)
    url_to_sign += '?' + params_to_sign unless params_to_sign.nil? || ['POST', 'PUT'].include?(http_method)

    # puts url_to_sign
    timestamp = Time.now.to_i.to_s

    token = create_signature(@uid, @api_key, timestamp, http_method, url_to_sign, params)

    req.add_field('X-OnePageCRM-UID', @uid)
    req.add_field('X-OnePageCRM-TS', timestamp)
    req.add_field('X-OnePageCRM-Auth', token)
  end


  def create_signature(uid, api_key, timestamp, request_type, request_url, request_body)

    request_url_hash = Digest::SHA1.hexdigest request_url
    request_body_hash = Digest::SHA1.hexdigest request_body.to_json
    signature_message = [uid, timestamp, request_type.upcase, request_url_hash].join '.'
    signature_message += ('.' + request_body_hash) unless request_body.empty?
    OpenSSL::HMAC.hexdigest('sha256', api_key, signature_message).to_s
  end


end
