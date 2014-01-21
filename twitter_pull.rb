require 'selenium-webdriver'
require './twitter_csv'

def get_twitter_data
	profile = Selenium::WebDriver::Firefox::Profile.new
	profile['browser.download.dir'] = "~/nest/adcosttracking"
	profile['browser.download.folderList'] = 2
	profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/csv'
	profile['pdfjs.disabled'] = true

	driver = Selenium::WebDriver.for :firefox, :profile => profile
	driver.manage.window.resize_to(800,800)

	# Load personal data (login/password)
  	# from persoal_data.json.
  	personal_data = JSON.parse(File.read('personal_data.json'))["download"]["twitter"]

	driver.navigate.to "https://ads.twitter.com/accounts/2s6hi3/campaigns"
	username = driver.find_elements(:name, 'user_identifier')[1]
	password = driver.find_elements(:name, 'password')[1]
	username.send_keys personal_data["login"]
	password.send_keys personal_data["password"]
	password.submit

	campaigns = driver.find_elements(:id, "sortableRow-2")
	campaigns.each do |campaign|
		status = campaign.find_element(:class, "status-label")
		if status.text == "ACTIVE"
			campaign.find_element(:class, "download-csv-link").click
			title = campaign.find_element(:class, "campaign-dashboard-link").text
			convert_and_upload("Daily spend report for_ " + title + ".csv")
		end
	end

	driver.quit
end

if __FILE__ == $0
	get_twitter_data
end