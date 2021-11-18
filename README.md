# IP2Location D Library

This D library provides a fast lookup of country, region, city, latitude, longitude, ZIP code, time zone, ISP, domain name, connection type, IDD code, area code, weather station code, station name, mcc, mnc, mobile brand, elevation, usage type, address type and IAB category from IP address by using IP2Location database. This library uses a file based database available at IP2Location.com. This database simply contains IP blocks as keys, and other information such as country, region, city, latitude, longitude, ZIP code, time zone, ISP, domain name, connection type, IDD code, area code, weather station code, station name, mcc, mnc, mobile brand, elevation, usage type, address type and IAB category as values. It supports both IP address in IPv4 and IPv6.

This library can be used in many types of projects such as:

 - select the geographically closest mirror
 - analyze your web server logs to determine the countries of your visitors
 - credit card fraud detection
 - software export controls
 - display native language and currency 
 - prevent password sharing and abuse of service 
 - geotargeting in advertisement

The database will be updated on a monthly basis for greater accuracy. Free LITE databases are available at https://lite.ip2location.com/ upon registration.

The paid databases are available at https://www.ip2location.com under Premium subscription package.

As an alternative, this module can also call the IP2Location Web Service. This requires an API key. If you don't have an existing API key, you can subscribe for one at the below:

https://www.ip2location.com/web-service/ip2location

## Installation

To install this library using dub:

```
"dependencies": {
    "ip2location-d": "~master"
}
```

## QUERY USING THE BIN FILE

## Dependencies

This library requires IP2Location BIN data file to function. You may download the BIN data file at
* IP2Location LITE BIN Data (Free): https://lite.ip2location.com
* IP2Location Commercial BIN Data (Comprehensive): https://www.ip2location.com


## IPv4 BIN vs IPv6 BIN

Use the IPv4 BIN file if you just need to query IPv4 addresses.

Use the IPv6 BIN file if you need to query BOTH IPv4 and IPv6 addresses.


## Methods

Below are the methods supported in this library.

|Method Name|Description|
|---|---|
|get_all|Returns the geolocation information in an object.|
|get_country_short|Returns the country code.|
|get_country_long|Returns the country name.|
|get_region|Returns the region name.|
|get_city|Returns the city name.|
|get_isp|Returns the ISP name.|
|get_latitude|Returns the latitude.|
|get_longitude|Returns the longitude.|
|get_domain|Returns the domain name.|
|get_zipcode|Returns the ZIP code.|
|get_timezone|Returns the time zone.|
|get_netspeed|Returns the net speed.|
|get_iddcode|Returns the IDD code.|
|get_areacode|Returns the area code.|
|get_weatherstationcode|Returns the weather station code.|
|get_weatherstationname|Returns the weather station name.|
|get_mcc|Returns the mobile country code.|
|get_mnc|Returns the mobile network code.|
|get_mobilebrand|Returns the mobile brand.|
|get_elevation|Returns the elevation in meters.|
|get_usagetype|Returns the usage type.|
|get_addresstype|Returns the address type.|
|get_category|Returns the IAB category.|
|close|Closes BIN file and resets metadata.|

## Usage

```d
import std.stdio;
import ip2location : ip2location;

int main() {
	string db = "./IPV6-COUNTRY-REGION-CITY-LATITUDE-LONGITUDE-ZIPCODE-TIMEZONE-ISP-DOMAIN-NETSPEED-AREACODE-WEATHER-MOBILE-ELEVATION-USAGETYPE-ADDRESSTYPE-CATEGORY.BIN";
	ip2location ip2loc = new ip2location(db);
	auto results = ip2loc.get_all("8.8.8.8");
	
	writeln("country_short: ", results.country_short);
	writeln("country_long: ", results.country_long);
	writeln("region: ", results.region);
	writeln("city: ", results.city);
	writeln("isp: ", results.isp);
	writefln("latitude: %f", results.latitude);
	writefln("longitude: %f", results.longitude);
	writeln("domain: ", results.domain);
	writeln("zipcode: ", results.zipcode);
	writeln("timezone: ", results.timezone);
	writeln("netspeed: ", results.netspeed);
	writeln("iddcode: ", results.iddcode);
	writeln("areacode: ", results.areacode);
	writeln("weatherstationcode: ", results.weatherstationcode);
	writeln("weatherstationname: ", results.weatherstationname);
	writeln("mcc: ", results.mcc);
	writeln("mnc: ", results.mnc);
	writeln("mobilebrand: ", results.mobilebrand);
	writefln("elevation: %f", results.elevation);
	writeln("usagetype: ", results.usagetype);
	writeln("addresstype: ", results.addresstype);
	writeln("category: ", results.category);
	
	writeln("API Version: ", ip2loc.api_version());
	ip2loc.close();
	return 0;
}
```

## QUERY USING THE IP2LOCATION WEB SERVICE

## Methods
Below are the methods supported in this library.

|Method Name|Description|
|---|---|
|open| 3 input parameters:<ol><li>IP2Location API Key.</li><li>Package (WS1 - WS25)</li></li><li>Use HTTPS or HTTP</li></ol> |
|lookup|Query IP address. This method returns an object containing the geolocation info. <ul><li>country_code</li><li>country_name</li><li>region_name</li><li>city_name</li><li>latitude</li><li>longitude</li><li>zip_code</li><li>time_zone</li><li>isp</li><li>domain</li><li>net_speed</li><li>idd_code</li><li>area_code</li><li>weather_station_code</li><li>weather_station_name</li><li>mcc</li><li>mnc</li><li>mobile_brand</li><li>elevation</li><li>usage_type</li><li>address_type</li><li>category</li><li>continent<ul><li>name</li><li>code</li><li>hemisphere</li><li>translations</li></ul></li><li>country<ul><li>name</li><li>alpha3_code</li><li>numeric_code</li><li>demonym</li><li>flag</li><li>capital</li><li>total_area</li><li>population</li><li>currency<ul><li>code</li><li>name</li><li>symbol</li></ul></li><li>language<ul><li>code</li><li>name</li></ul></li><li>idd_code</li><li>tld</li><li>translations</li></ul></li><li>region<ul><li>name</li><li>code</li><li>translations</li></ul></li><li>city<ul><li>name</li><li>translations</li></ul></li><li>geotargeting<ul><li>metro</li></ul></li><li>country_groupings</li><li>time_zone_info<ul><li>olson</li><li>current_time</li><li>gmt_offset</li><li>is_dst</li><li>sunrise</li><li>sunset</li></ul></li><ul>|
|get_credit|This method returns the web service credit balance in an object.|

## Usage

```d
import std.stdio;
import ip2locationwebservice : ip2locationwebservice;
import std.json;

int main() {
	auto ip = "8.8.8.8";
	auto apikey = "YOUR_API_KEY";
	auto apipackage = "WS25";
	auto usessl = true;
	
	// addon and lang to get more data and translation (leave both blank if you don't need them)
	auto addon = "continent,country,region,city,geotargeting,country_groupings,time_zone_info";
	auto lang = "es";
	
	auto ws = new ip2locationwebservice();
	
	ws.open(apikey, apipackage, usessl);
	
	auto result = ws.lookup(ip, addon, lang);
	
	if (("response" in result) && (result["response"].str == "OK")) {
		// standard results
		writefln("country_code: %s", ("country_code" in result) ? result["country_code"].str : "");
		writefln("country_name: %s", ("country_name" in result) ? result["country_name"].str : "");
		writefln("region_name: %s", ("region_name" in result) ? result["region_name"].str : "");
		writefln("city_name: %s", ("city_name" in result) ? result["city_name"].str : "");
		writefln("latitude: %f", ("latitude" in result) ? result["latitude"].floating : 0.0);
		writefln("longitude: %f", ("longitude" in result) ? result["longitude"].floating : 0.0);
		writefln("zip_code: %s", ("zip_code" in result) ? result["zip_code"].str : "");
		writefln("time_zone: %s", ("time_zone" in result) ? result["time_zone"].str : "");
		writefln("isp: %s", ("isp" in result) ? result["isp"].str : "");
		writefln("domain: %s", ("domain" in result) ? result["domain"].str : "");
		writefln("net_speed: %s", ("net_speed" in result) ? result["net_speed"].str : "");
		writefln("idd_code: %s", ("idd_code" in result) ? result["idd_code"].str : "");
		writefln("area_code: %s", ("area_code" in result) ? result["area_code"].str : "");
		writefln("weather_station_code: %s", ("weather_station_code" in result) ? result["weather_station_code"].str : "");
		writefln("weather_station_name: %s", ("weather_station_name" in result) ? result["weather_station_name"].str : "");
		writefln("mcc: %s", ("mcc" in result) ? result["mcc"].str : "");
		writefln("mnc: %s", ("mnc" in result) ? result["mnc"].str : "");
		writefln("mobile_brand: %s", ("mobile_brand" in result) ? result["mobile_brand"].str : "");
		writefln("elevation: %d", ("elevation" in result) ? result["elevation"].integer : 0);
		writefln("usage_type: %s", ("usage_type" in result) ? result["usage_type"].str : "");
		writefln("address_type: %s", ("address_type" in result) ? result["address_type"].str : "");
		writefln("category: %s", ("category" in result) ? result["category"].str : "");
		writefln("category_name: %s", ("category_name" in result) ? result["category_name"].str : "");
		writefln("credits_consumed: %d", ("credits_consumed" in result) ? result["credits_consumed"].integer : 0);
		
		// continent addon
		if ("continent" in result) {
			auto continent = result["continent"];
			writefln("continent => name: %s", continent["name"].str);
			writefln("continent => code: %s", continent["code"].str);
			writefln("continent => hemisphere: %s", continent["hemisphere"]);
			writefln("continent => translations: %s", continent["translations"][lang].str);
		}
		
		// country addon
		if ("country" in result) {
			auto country = result["country"];
			writefln("country => name: %s", country["name"].str);
			writefln("country => alpha3_code: %s", country["alpha3_code"].str);
			writefln("country => numeric_code: %s", country["numeric_code"].str);
			writefln("country => demonym: %s", country["demonym"].str);
			writefln("country => flag: %s", country["flag"].str);
			writefln("country => capital: %s", country["capital"].str);
			writefln("country => total_area: %s", country["total_area"].str);
			writefln("country => population: %s", country["population"].str);
			writefln("country => idd_code: %s", country["idd_code"].str);
			writefln("country => tld: %s", country["tld"].str);
			writefln("country => translations: %s", country["translations"][lang].str);
			
			writefln("country => currency => code: %s", country["currency"]["code"].str);
			writefln("country => currency => name: %s", country["currency"]["name"].str);
			writefln("country => currency => symbol: %s", country["currency"]["symbol"].str);
			
			writefln("country => language => code: %s", country["language"]["code"].str);
			writefln("country => language => name: %s", country["language"]["name"].str);
		}
		
		// region addon
		if ("region" in result) {
			auto region = result["region"];
			writefln("region => name: %s", region["name"].str);
			writefln("region => code: %s", region["code"].str);
			writefln("region => translations: %s", region["translations"][lang].str);
		}
		
		// city addon
		if ("city" in result) {
			auto city = result["city"];
			writefln("city => name: %s", city["name"].str);
			// may not have translations for city names
			writefln("city => translations: %s", (city["translations"].type == JSONType.object) ? city["translations"][lang].str : "");
		}
		
		// geotargeting addon
		if ("geotargeting" in result) {
			writefln("geotargeting => metro: %s", result["geotargeting"]["metro"].str);
		}
		
		// country_groupings addon
		if ("country_groupings" in result) {
			auto groupings = result["country_groupings"];
			
			for (int x = 0; x < groupings.array.length; x++) {
				writefln("country_groupings => #%s => acronym: %s", x, groupings[x]["acronym"].str);
				writefln("country_groupings => #%s => name: %s", x, groupings[x]["name"].str);
			}
		}
		
		// time_zone_info addon
		if ("time_zone_info" in result) {
			auto timezone = result["time_zone_info"];
			writefln("time_zone_info => olson: %s", timezone["olson"].str);
			writefln("time_zone_info => current_time: %s", timezone["current_time"].str);
			writefln("time_zone_info => gmt_offset: %d", timezone["gmt_offset"].integer);
			writefln("time_zone_info => is_dst: %s", timezone["is_dst"].str);
			writefln("time_zone_info => sunrise: %s", timezone["sunrise"].str);
			writefln("time_zone_info => sunset: %s", timezone["sunset"].str);
		}
	}
	else if ("response" in result) {
		writefln("Error: %s", result["response"]);
	}
	else {
		writeln("Error: Unknown error.");
	}
	
	auto result2 = ws.get_credit();
	
	if ("response" in result2) {
		writefln("Credit balance: %d", result2["response"].integer);
	}
	else {
		writeln("Error: Unknown error.");
	}
	
	return 0;
}
```