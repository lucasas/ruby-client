require 'onepageapi'
require 'json_spec'

api_login = 'peter+owner@xap.ie' # put your login details here
api_pass = 'p3t3r3t3p' # put your password here

describe 'OnePageAPISamples' do
  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login

  it 'checks samples bootstrap' do
    samples.bootstrap['status'].should be == 0
    samples.bootstrap['data']['user']['user']['email'].should be == api_login
    samples.bootstrap.to_json.should have_json_path('data')
  end

  it 'check action_stream' do
    action_stream = samples.get_action_stream
    expect { action_stream }.to_not raise_error
  end

  it 'check get_contact_details' do
    contact_id = samples.get_contacts_list[0]['contact']['id']
    expect { samples.get_contact_details(contact_id) }.to_not raise_error
  end

  it 'should create a new contact', pending: false do
    new_contact_details = ({
      'first_name' => 'Johnny',
      'last_name' => 'Deer',
      'company_name' => 'ACMEinc',
      'starred' => true,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@exammmple.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE'
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']
    expect(got_deets['first_name']).to eq(new_contact_details['first_name'])

    new_contact_details.each do |k, v|
      expect(got_deets[k]).to eq(new_contact_details[k])
    end
  end

  it 'should update a contact', pending: false do
    new_contact_details = ({
      'first_name' => 'Johnny',
      'last_name' => 'Deer',
      'company_name' => 'ACMEinc',
      'starred' => true,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@exammmple.com' }],
      'background' => '1BACKGROUND',
      'job_title' => '1JOBTITLE'
    })
    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']

    changed_contact_details = ({
      'first_name' => 'John',
      'last_name' => 'Deer',
      'company_name' => 'ACME Inc.',
      'starred' => false,
      'emails' => [{
          'type' => 'work',
          'value' => 'john@example.com' }],
      'background' => '2BACKGROUND',
      'job_title' => '2JOBTITLE'
    })
    samples.update_contact(new_contact_id, changed_contact_details)

    updated_deets = samples
                    .get_contact_details(new_contact_id)['data']['contact']
    changed_contact_details.each do |k, v|
      expect(updated_deets[k]).to eq(changed_contact_details[k])
    end

  end

  it 'should delete the new contact' do
    new_contact_details = ({
      'first_name' => 'Johnny',
      'last_name' => 'Deer',
      'company_name' => 'ACMEinc',
      'starred' => true,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@exammmple.com' }]
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
    got_deets = samples.get_contact_details(new_contact_id)['data']['contact']
    expect(got_deets['first_name']).to eq(new_contact_details['first_name'])

    samples.delete_contact(new_contact_id)
    expect(samples.get_contact_details(new_contact_id)['status']).to be 404
  end



end

describe ' Test status methods ' do 

  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login


  it 'should get statuses ', pending: true do 
    statuses = samples.get_statuses
    # puts statuses['data']
  end

  it 'should match status names with returned from contats', pending: true do
    contacts = samples.get_contacts_list
    contacts.each do |contact|
      # puts contact['contact']
    end

  end


end

describe 'Test change auth key and logout' do

  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login
  it 'should change auth key' do
    orig_auth_key = samples.bootstrap['data']['auth_key']
    samples.change_auth_key
    new_auth_key = samples.bootstrap['data']['auth_key']
    orig_auth_key.should_not be == new_auth_key
  end

  it 'should log us out' do
    samples.logout['status'].should == 0
  end

end

describe 'Test subuser' do
  sub_login = 'peter+subuser@xap.ie'
  sub_pass = 'p3t3r3t3p'
  samples = OnePageAPISamples.new(sub_login, sub_pass)
  samples.login
  it 'should create a new user owned by subuser' do
    new_contact_details = ({
      'first_name' => 'API',
      'last_name' => 'SUBUSER',
      'company_name' => 'API',
      'starred' => false,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@subuser.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE'
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
   
    owner_id = samples.get_contact_details(new_contact_id)['data']['contact']['owner_id']

    expect(owner_id).to eq(samples.return_uid)

  end

  it 'should create a new user owned by owner' do

   new_contact_details = ({
      'first_name' => 'API',
      'last_name' => 'OWNER',
      'company_name' => 'API',
      'starred' => false,
      'tags' => %w[api_test1 api_test2],
      'emails' => [{
          'type' => 'work',
          'value' => 'johnny@subuser.com' }],
      'background' => 'BACKGROUND',
      'job_title' => 'JOBTITLE',
      'owner_id' =>'5376256f1da41728a5000003'
    })

    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']
   
    owner_id = samples.get_contact_details(new_contact_id)['data']['contact']['owner_id']

    expect(owner_id).to eq('5376256f1da41728a5000003')

  end
end


describe 'Test Actions' do
  samples = OnePageAPISamples.new(api_login, api_pass)
  samples.login

  new_contact_details = ({
      'first_name' => 'Action',
      'last_name' => 'Tester',
      'company_name' => 'Action Tester',
      'starred' => true,
    })
    new_contact = samples.create_contact(new_contact_details)
    new_contact_id = new_contact['contact']['id']

  it 'should create an action' do
    action_details = ({
      'contact_id' => new_contact_id,
      'assignee_id' => samples.return_uid,
      'date' => '2014-05-30',
      'text' => 'Test Action',
      'status' => 'date'
      })
    action = samples.create_action(new_contact_id, action_details)
    puts action
    action['status'].should be 200
    
  end
end

