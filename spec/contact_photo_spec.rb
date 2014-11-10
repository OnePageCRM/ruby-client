require 'onepageapi'
require 'json_spec'
require 'base64'

samples = OnePageAPI.new
samples.login

describe 'Contact Photo' do
  before(:each) do
    new_contact_details = ({
      'first_name' => 'Photo',
      'last_name' => 'Contact'
    })

    new_contact = samples.create_contact(new_contact_details)
    @new_contact_id = new_contact['contact']['id']
  end

  after(:each) do
    samples.delete("contacts/#{@new_contact_id}.json")
  end
 
  it 'should upload a jpg photo' do
    image = File.open('testimages/mic.jpg', 'r')
    base64_image = Base64.encode64(image.read)
    response = samples.put("contacts/#{@new_contact_id}/contact_photo.json", 'image' => base64_image)
    expect(response['status']).to be 0
    expect(response['data']['contact']['id']).to eq @new_contact_id
    expect(response['data']['contact']['photo_url']).not_to be nil
  end

  it 'should upload a png photo' do
    image = File.open('testimages/mic.png', 'r')
    base64_image = Base64.encode64(image.read)
    response = samples.put("contacts/#{@new_contact_id}/contact_photo.json", 'image' => base64_image)
    expect(response['status']).to be 0
    expect(response['data']['contact']['id']).to eq @new_contact_id
    expect(response['data']['contact']['photo_url']).not_to be nil
  end

  it 'should upload a png pretending to be a jpg' do
    image = File.open('testimages/png_type.jpg', 'r')
    base64_image = Base64.encode64(image.read)
    response = samples.put("contacts/#{@new_contact_id}/contact_photo.json", 'image' => base64_image)
    expect(response['status']).to be 0
    expect(response['data']['contact']['id']).to eq @new_contact_id
    expect(response['data']['contact']['photo_url']).not_to be nil
  end

end
