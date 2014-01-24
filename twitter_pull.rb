require 'selenium-webdriver'
require 'headless'
require './twitter_csv'

def get_twitter_data
	headless = Headless.new(reuse: true, destroy_at_exit:false)
	headless.start

	# profile = Selenium::WebDriver::Firefox::Profile.new
	# profile['browser.download.dir'] = "~/adcosttracker"
	# profile['browser.download.folderList'] = 2
	# profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/csv'
	# profile['pdfjs.disabled'] = true

	prof = Selenium::WebDriver::Firefox::Profile.from_name('WebDriver')

	driver = Selenium::WebDriver.for :firefox, :profile => prof

	# Load personal data (login/password)
	# from persoal_data.json.
	personal_data = JSON.parse(File.read('personal_data.json'))["download"]["twitter"]

	driver.navigate.to "https://twitter.com/login?redirect_after_login=https%3A%2F%2Fads.twitter.com%2Faccounts%#{personal_data["accountId"]}%2Fcampaigns_dashboard"
	wait = Selenium::WebDriver::Wait.new(:timeout => 15) # seconds
	
	if driver.title != "Campaign overview - Twitter Ads"
		username = driver.find_elements(:name, 'session[username_or_email]')[1]
		password = driver.find_elements(:name, 'session[password]')[1]
		username.send_keys personal_data["login"]
		password.send_keys personal_data["password"]
		password.submit
	        
		wait.until { driver.find_element(:class, 'popup-close') }	
		driver.find_element(:class, 'popup-close').click
        end 
	
	wait.until { driver.find_element(:class, 'csvButtonContainer') }
	driver.find_element(:class, 'csvButtonContainer').click
	sleep(8)
	Puts "Downloaded"
	
	convert_and_upload("metrics.csv")
	driver.quit
end

if __FILE__ == $0
	get_twitter_data
end
