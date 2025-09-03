import std.stdio;
import ip2location : ip2location;
import ip2locationwebservice : ip2locationwebservice;
import std.json;

int main() {
	// Query using BIN file
	string db = "./IPV6-COUNTRY-REGION-CITY-LATITUDE-LONGITUDE-ZIPCODE-TIMEZONE-ISP-DOMAIN-NETSPEED-AREACODE-WEATHER-MOBILE-ELEVATION-USAGETYPE-ADDRESSTYPE-CATEGORY-DISTRICT-ASN.BIN";
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
	writeln("district: ", results.district);
	writeln("asn: ", results.asn);
	writeln("as: ", results.as);
	writeln("asdomain: ", results.asdomain);
	writeln("asusagetype: ", results.asusagetype);
	writeln("ascidr: ", results.ascidr);
	
	writeln("API Version: ", ip2loc.api_version());
	ip2loc.close();
	
	// Query using web service
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
