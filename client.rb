require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'time'
require 'json'

def upload(file_name)
  # Initialize the client.
  client = Google::APIClient.new(
    :application_name => 'Twitter CSV Upload',
    :application_version => '1.0.0'
  )

  # Initialize analytics. Note this will make a request to the
  # discovery service every time, so be sure to use serialization
  # in your production code. Check the samples for more details.
  analytics = client.discovered_api('analytics', 'v3')

  # Load client secrets from your client_secrets.json.
  client_secrets = Google::APIClient::ClientSecrets.load

  # Load personal data (acct info, custom data source, web property id)
  # from persoal_data.json.
  personal_data = JSON.parse(File.read('personal_data.json'))

  # Run installed application flow. Check the samples for a more
  # complete example that saves the credentials between runs.
  flow = Google::APIClient::InstalledAppFlow.new(
    :client_id => client_secrets.client_id,
    :client_secret => client_secrets.client_secret,
    :scope => ['https://www.googleapis.com/auth/analytics']
  )
  client.authorization = flow.authorize


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
                    'customDataSourceId'  => personal_data['customDataSourceId'],
                    'date'                => t,
                    'type'                => "cost",
                    'webPropertyId'       => personal_data['webPropertyId']
                  },
    :media       => media,
    :body_object => metadata
  )

  puts result.data.to_hash
end

if __FILE__ == $0
  upload(ARGV[0])
end