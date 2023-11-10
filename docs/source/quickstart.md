# Quickstart

## Dependencies

This library requires IP2Location BIN database to function. You may
download the BIN database at

-   IP2Location LITE BIN Data (Free): <https://lite.ip2location.com>
-   IP2Location Commercial BIN Data (Comprehensive):
    <https://www.ip2location.com>

## Installation

To install this library using dub:

```
"dependencies": {
    "ip2location-d": "~master"
}
```

## Sample Codes

### Query geolocation information from BIN database

You can query the geolocation information from the IP2Location BIN database as below:

```d
import std.stdio;
import ip2location : ip2location;

int main() {
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
	
	writeln("API Version: ", ip2loc.api_version());
	ip2loc.close();
	return 0;
}
```