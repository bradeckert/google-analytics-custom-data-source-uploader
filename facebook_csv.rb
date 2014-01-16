require 'csv'
require 'json'
require 'net/http'
require 'time'


#  Calls the facebook ad API to get ad data 
#  and converts it to a CSV for google analytics 
#
#  Output: CSV ready to be uploaded to GA
$order_out = ['ga:source','ga:medium','ga:campaign','ga:adCost','ga:adClicks','ga:impressions']

def convert(ad_account_id, facebook_out_file_path)
	base_url = "https://graph.facebook.com/act_#{ad_account_id}/stats"
	t = Time.now
	url = "#{base_url}?start_time=#{t.year}-#{t.month}-#{t.day-1}T00:00:00&end_time=#{t.year}-#{t.month}-#{t.day-1}T12:00:00"
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

if __FILE__ == $0
	convert(ARGV[0], ARGV[1])
end