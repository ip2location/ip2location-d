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
