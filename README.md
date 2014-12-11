# OnePageCRM Ruby API Client

This is a short ruby script to help you get started with the OnePageCRM API v3.
It only contains a small subsection of calls and functions available using the API.

## How I install it?

Add `gem "onepageapi"` to your `Gemfile` and run `bundle install`

or

Just run `gem install onepageapi`

## Getting started

- set your api_login and apt_password
```ruby
    > api_login = 'you@example.com'
    > api_pass = 'youronpagepassword'
```
- copy the config/config_orig.yml file to config/config.yml and add your OnePageCRM login and password.

- Create a new samples object and login
    > samples = OnePageAPI.new(api_login, api_pass)
    > samples.login

- Run the different commands - for example:
    > samples.get('bootstrap.json')
    > samples.get('contacts.json')
    > samples.post('contacts.json', contact_data)
    > samples.put('contacts/#{contact_id}.json', updated_contact_data)
