#Google Analytics Custom Data Source Uploader, v0.1.0
==================================

##:newspaper: Description
This ruby script imports data (cost, clicks, etc.) from facebook and twitter ad campaigns into Google Analytics. Both facebook and twitter keep track of tons of data about an ad campaign: how much you spend, how many clicks that generated, conversion rate, etc. As of now there is no easy way to get this data into Google Analytics to better monitor which campaigns are the most effective. This goal of this project is to fetch your data from a third party (or just given a csv file), and import it automatically into Google once per day.

##:notebook: Setup:
1. Make sure you have Ruby installed
2. Go to Google Analytics, [setup a Service Account](https://developers.google.com/console/help/#service_accounts), and download a .p12 private key file. Name it `privatekey.p12` and move it in the directory.
3. On the Analytics Admin dashboard, create a custom data source named something like "twitter.com" or "facebook.com", and get the `customDataSourceId` variable.
4. Figure out what dimentions you will require from a twitter/facebook csv and on Google Analytics - [More info here](https://developers.google.com/analytics/devguides/platform/cost-data-import#dims_mets)
5. If you require different dimentions from what I used (shown below), you must edit the `twitter_csv.rb` and `facebook_csv.rb` to reflect what you want. Change the `$order_out=[ga:dimensions]` variable and the `out_temp=[csv dimensions]` lines.
6. Create a personal_data.json file in the directory, format below.


##:mega: Executing the script
Note: As of version 0.1.0, api requests to facebook are not supported.

* Twitter: Run `ruby twitter_csv.rb [out_name].csv [in_name].csv`
* Facebook: Run `ruby facebook_csv.rb [out_name].csv [in_name].csv`


##:blue_book: Formatting
### Here are the Google Analytics dimensions and twitter/facebook:

	Google 			| Facebook 	   | Twitter
	----------------|--------------|--------------
	ga:source 		| facebook.com | twitter.com
	ga:medium 		| cpc 		   | product type
	ga:campaign 	| Campaign 	   | campaign
	ga:adCost 		| Spend (USD)  | Spend
	ga:adClicks 	| Clicks 	   | Clicks
	ga:impressions  | Impressions  | Impressions

### Format of personal_data.json: (None of this needs to be encrypted)
```json
{
	"accountId":"XXXXXXXX",
	"webPropertyId":"UA-XXXXXXXX-X",
	"serviceEmail":"XXX@developer.gserviceaccount.com",
	"customDataSourceId":
	{
		"twitter":"XXXXXXXXXXXXXX",
		"facebook":"XXXXXXXXXXXXXX"
	}
}
```

##:exclamation: TODO:

* Enable support for auto data fetch from both facebook and twitter by hitting their ads API. 
	Twitter's API is in beta and only certain companies have access
	Facebook requires the account to be a developer and you must create an app to get a secret key.
* Deploy so this runs automatically each day
* Turn into a ruby gem for easy install

