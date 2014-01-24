#Google Analytics Custom Data Source Uploader, v1.0.0
==================================

##:newspaper: Description
This ruby script imports data (cost, clicks, etc.) from facebook and twitter ad campaigns into Google Analytics. Both facebook and twitter keep track of tons of data about an ad campaign: how much you spend, how many clicks that generated, conversion rate, etc. As of now there is no easy way to get this data into Google Analytics to better monitor which campaigns are the most effective. This goal of this project is to fetch your data from a third party (or just given a csv file), and import it automatically into Google once per day.

##:notebook: Setup:
1. Make sure you have Ruby installed, along with Firefox
2. Go to Google Analytics, [setup a Service Account](https://developers.google.com/console/help/#service_accounts), and download a .p12 private key file. Name it `privatekey.p12` and move it in the directory.
3. On the Analytics Admin dashboard, create a custom data source named something like "twitter.com" or "facebook.com", and get the `customDataSourceId` variable.
4. Figure out what dimentions you will require from a twitter/facebook csv and on Google Analytics - [More info here](https://developers.google.com/analytics/devguides/platform/cost-data-import#dims_mets)
5. If you require different dimentions from what I used (shown below), you must edit the `twitter_csv.rb` and `facebook_csv.rb` to reflect what you want. Change the `$order_out=[ga:dimensions]` variable and the `out_temp=[csv dimensions]` lines.
6. Create a personal_data.json file in the directory, format below.
7. If you want this to run headless, must be done on an ubuntu server. Otherwise you must comment out the top two lines in both `twitter_pull.csv` and `fb_pull.csv`.
8. Set up the ubuntu server with firefox, rbenv, ruby 2.0.0-p353, git, and bundler. For development make sure your computer has X11 if on a mac.
9. In ubuntu run `firefox -profilemanager` and create a new profile (or load the example provided in `/firefox_profile/`).
10. Create a new profile and go to the twitter campaigns page, login, and download a CSV. Click "Don't ask to download file of this type" checkbox.
11. You are ready to go! See Executing the script below.


##:mega: Executing the script
* Twitter: Run `ruby twitter_pull.rb`
* Facebook: Run `ruby fb_pull.rb`


##:blue_book: Formatting
### Here are the Google Analytics dimensions and twitter/facebook:

	Google 			| Facebook 	   | Twitter
	----------------|--------------|--------------
	ga:source 		| facebook.com | twitter.com
	ga:medium 		| cpc 		   | Product type
	ga:campaign 	| Campaign 	   | Campaign name
	ga:adCost 		| Spend (USD)  | Campaign Daily spend
	ga:adClicks 	| Clicks 	   | Total engagements/follows
	ga:impressions  | Impressions  | Total impressions

### Format of personal_data.json: 
```json
{
	"upload":
	{
		"accountId":"XXXXXXXX",
		"webPropertyId":"UA-XXXXXXXX-X",
		"serviceEmail":"XXXXXXX@developer.gserviceaccount.com",
		"customDataSourceId":
		{
			"twitter":"XXXXXXXXXXXXXXXXXXXXXX",
			"facebook":"XXXXXXXXXXXXXXXXXXXXX"
		}
	},
	"download":
	{
		"twitter":
		{
			"login": "XXXXXXX",
			"password": "XXXXXXXX"
		},
		"facebook":
		{
			"login": "XXXXXXX",
			"password": "XXXXXXXXXX",
			"accountId": "XXXXXXXXXXXXXXXX"
		}
	}
}
```

##:exclamation: TODO:

* Enable support for auto data fetch from both facebook and twitter by hitting their ads API. 
	Both Twitter and Facebook's API's are in beta and only certain companies have access
* Deploy so this runs automatically each day
* Turn into a ruby gem for easy install

