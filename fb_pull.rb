require 'selenium-webdriver'
require './facebook_csv'

def get_facebook_data
	profile = Selenium::WebDriver::Firefox::Profile.new
	profile['browser.download.dir'] = "~/nest/adcosttracking"
	profile['browser.download.folderList'] = 2
	profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/csv'
	profile['pdfjs.disabled'] = true

	driver = Selenium::WebDriver.for :phantomjs
	#driver.manage.window.resize_to(800,800)

	# Load personal data (login/password)
  	# from persoal_data.json.
  	personal_data = JSON.parse(File.read('personal_data.json'))["download"]["facebook"]

	driver.navigate.to "https://www.facebook.com/ads/manage/reporting.php?act=#{personal_data["acccountId"]}"
	username = driver.find_element(:id, 'email')
	password = driver.find_element(:id, 'pass')
	username.send_keys personal_data["login"]
	password.send_keys personal_data["password"]
	password.submit

	wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
	wait.until { driver.find_element(:class, "bt-export-button") }

	export_button = driver.find_element(:class, "bt-export-button")
	export_button.click
	wait.until { driver.find_element(:class, "btMenuItem") }

	items = driver.find_elements(:class, "btMenuItem")
	items.each do |item|
		if item.attribute("data-ref") == "csv"
			item.click
		end
	end

	# wait for download to complete
	sleep(1)

	t = Time.now
	today = t.strftime "%Y-%m-%d"
	convert_and_upload("General Metrics, #{t.year}-#{t.strftime("%m")}-#{t.day-6} - #{t.year}-#{t.strftime("%m")}-#{t.day+1}.csv")

	driver.quit
end

if __FILE__ == $0
	get_facebook_data
end