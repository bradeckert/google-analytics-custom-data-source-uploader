require 'csv'
require 'json'
require 'net/http'
require 'time'
require './client'

#  Calls the facebook ad API to get ad data 
#  and converts it to a CSV for google analytics 
#
#  Output: CSV ready to be uploaded to GA
$order_out = ['ga:source','ga:medium','ga:campaign','ga:adCost','ga:adClicks','ga:impressions']

def convert(facebook_in_file_path)
  # manually convert a facebook csv to correct format
  out = $order_out.to_csv
  CSV.foreach(facebook_in_file_path, :headers => true, :quote_char => "\'") do |row|
    out_temp = ['facebook.com', 'cpc', row['Campaign'], row["\"Spend (USD)\""], row['Clicks'], row['Impressions']]
    out += out_temp.to_csv
  end
  File.open("out_#{facebook_in_file_path}", "wb") { |file| file.write(out) } 
  puts "Converted"
  File.delete(facebook_in_file_path)
  return "out_#{facebook_in_file_path}"
end

def convert_and_upload(facebook_in_file_path)
  facebook_out_file_path = convert(facebook_in_file_path)
  upload('facebook', facebook_out_file_path)
end

if __FILE__ == $0
  facebook_out_file_path = convert(ARGV[0])
  upload('facebook', facebook_out_file_path)
end
