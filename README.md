IP2Location D Library
=====================

This D library provides a fast lookup of country, region, city, latitude, longitude, ZIP code, time zone, ISP, domain name, connection type, IDD code, area code, weather station code, station name, mcc, mnc, mobile brand, elevation, and usage type from IP address by using IP2Location database. This library uses a file based database available at IP2Location.com. This database simply contains IP blocks as keys, and other information such as country, region, city, latitude, longitude, ZIP code, time zone, ISP, domain name, connection type, IDD code, area code, weather station code, station name, mcc, mnc, mobile brand, elevation, and usage type as values. It supports both IP address in IPv4 and IPv6.

This library can be used in many types of projects such as:

 - select the geographically closest mirror
 - analyze your web server logs to determine the countries of your visitors
 - credit card fraud detection
 - software export controls
 - display native language and currency 
 - prevent password sharing and abuse of service 
 - geotargeting in advertisement

The database will be updated in monthly basis for the greater accuracy. Free LITE databases are available at https://lite.ip2location.com/ upon registration.

The paid databases are available at https://www.ip2location.com under Premium subscription package.


Installation
============

To install this library using dub:

```
"dependencies": {
    "ip2location-d": "~master"
}
```

Example
=======

```d
import std.stdio;
import ip2location;

int main() {
	string db = "./IPV6-COUNTRY-REGION-CITY-LATITUDE-LONGITUDE-ZIPCODE-TIMEZONE-ISP-DOMAIN-NETSPEED-AREACODE-WEATHER-MOBILE-ELEVATION-USAGETYPE.BIN";
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
	
	writeln("API Version: ", ip2loc.api_version());
	return 0;
}
```


Dependencies
============

The complete database is available at http://www.ip2location.com under subscription package.


Copyright
=========

Copyright (C) 2016 by IP2Location.com, support@ip2location.com
