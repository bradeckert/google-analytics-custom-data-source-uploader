require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'time'
require 'json'

def upload(source, file_name)
  # Initialize the client.
  client = Google::APIClient.new(
    :application_name => 'Twitter/Facebook CSV Upload',
    :application_version => '1.0.0'
  )

  # Initialize analytics. Note this will make a request to the
  # discovery service every time, so be sure to use serialization
  # in your production code.
  analytics = client.discovered_api('analytics', 'v3')

  # Load client secrets from your client_secrets.json.
  key = Google::APIClient::PKCS12.load_key('privatekey.p12', 'notasecret')

  # Load personal data (acct info, custom data source, web property id)
  # from persoal_data.json.
  personal_data = JSON.parse(File.read('personal_data.json'))["upload"]

  # Authorize
  
  service_account = Google::APIClient::JWTAsserter.new(
    personal_data['serviceEmail'],
    'https://www.googleapis.com/auth/analytics',
    key
  )
  client.authorization = service_account.authorize

  t = Time.now
  t = t.strftime "%Y-%m-%d"
  # Make an API call.
  media = Google::APIClient::UploadIO.new(file_name, 'application/octet-stream')
  metadata = {
    'title'     => t + ":daily_upload",
    'mimeType'  => 'application/octet-stream',
    'resumable' => true
  }

  result = client.execute(
    :api_method => analytics.management.daily_uploads.upload,
    :parameters => {'uploadType'          => "multipart",
                    'accountId'           => personal_data['accountId'],
                    'appendNumber'        => 1,
                    'reset'               => true,
                    'customDataSourceId'  => personal_data['customDataSourceId'][source],
                    'date'                => t,
                    'type'                => "cost",
                    'webPropertyId'       => personal_data['webPropertyId']
                  },
    :media       => media,
    :body_object => metadata
  )
  # Uncomment this line to view the server response
  # puts result.data.to_hash
  puts "Uploaded"
end

if __FILE__ == $0
  upload(ARGV[0], ARGV[1])
end