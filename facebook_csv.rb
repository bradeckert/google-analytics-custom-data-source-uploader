require 'csv'
require 'json'
require 'net/http'
require 'time'


#  Calls the facebook ad API to get ad data 
#  and converts it to a CSV for google analytics 
#
#  Output: CSV ready to be uploaded to GA
$order_out = ['ga:source','ga:medium','ga:campaign','ga:adCost','ga:adClicks','ga:impressions']

def convert(facebook_out_file_path, facebook_in_file_path=nil)
  if(facebook_in_file_path)
    # manually convert a facebook csv to correct format
    out = $order_out.to_csv
    CSV.foreach(facebook_in_file_path, :headers => true) do |row|
      out_temp = ['facebook.com', 'cpc', row['Campaign'], row['Spend (USD)'], row['Clicks'], row['Impressions']]
      out += out_temp.to_csv
    end
    File.open(facebook_out_file_path, "wb") { |file| file.write(out) } 
  else
    puts "Wrong"
    # TODO: Need access tokens
    # This code will call facebook api and get ad data back
    # TODO: Add facebook acct info to personal_data.json
  	t = Time.now
    base_url = "https://graph.facebook.com/act_#{ad_account_id}/stats"
    start_time_url = "start_time=#{t.year}-#{t.month}-#{t.day-1}T00:00:00"
    end_time_url = "end_time=#{t.year}-#{t.month}-#{t.day-1}T12:00:00"
  	secret_url = "key=value&access_token=app_id|app_secret"

  	url = "#{base_url}?#{start_time_url}&#{end_time_url}?#{secret_url}"
  	resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body

    # JSON -> a hash
    result = JSON.parse(data)

    if result.has_key? 'error'
      raise "Facebook request error: " + result['error']['message']
    end
    
    out = $order_out.to_csv
    out_temp = [result['id'],result['this is wrong'],result['adcampaign_id'],
    						result['spent'],result['clicks'],result['impressions']]

    out += out_temp.to_csv
  	
  	File.open(facebook_out_file_path, "wb") { |file| file.write(out) }
  end
end

if __FILE__ == $0
	convert(ARGV[0], ARGV[1])
end