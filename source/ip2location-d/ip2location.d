import std.stdio;
import std.file;
import std.mmfile;
import std.bitmanip;
import std.bigint;
import std.socket;
import std.conv;

protected struct ip2locationmeta {
	ubyte databasetype;
	ubyte databasecolumn;
	ubyte databaseday;
	ubyte databasemonth;
	ubyte databaseyear;
	uint ipv4databasecount;
	uint ipv4databaseaddr;
	uint ipv6databasecount;
	uint ipv6databaseaddr;
	uint ipv4indexbaseaddr;
	uint ipv6indexbaseaddr;
	uint ipv4columnsize;
	uint ipv6columnsize;

}

protected struct ip2locationrecord {
	string country_short = "-";
	string country_long = "-";
	string region = "-";
	string city = "-";
	string isp = "-";
	float latitude = 0;
	float longitude = 0;
	string domain = "-";
	string zipcode = "-";
	string timezone = "-";
	string netspeed = "-";
	string iddcode = "-";
	string areacode = "-";
	string weatherstationcode = "-";
	string weatherstationname = "-";
	string mcc = "-";
	string mnc = "-";
	string mobilebrand = "-";
	float elevation = 0;
	string usagetype = "-";
}

protected struct ipv {
	uint iptype = 0;
	BigInt ipnum = BigInt("0");
	uint ipindex = 0; 
}

const ubyte[25] COUNTRY_POSITION = [0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2];
const ubyte[25] REGION_POSITION = [0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3];
const ubyte[25] CITY_POSITION = [0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
const ubyte[25] ISP_POSITION = [0, 0, 3, 0, 5, 0, 7, 5, 7, 0, 8, 0, 9, 0, 9, 0, 9, 0, 9, 7, 9, 0, 9, 7, 9];
const ubyte[25] LATITUDE_POSITION = [0, 0, 0, 0, 0, 5, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
const ubyte[25] LONGITUDE_POSITION = [0, 0, 0, 0, 0, 6, 6, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6];
const ubyte[25] DOMAIN_POSITION = [0, 0, 0, 0, 0, 0, 0, 6, 8, 0, 9, 0, 10,0, 10, 0, 10, 0, 10, 8, 10, 0, 10, 8, 10];
const ubyte[25] ZIPCODE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7, 7, 0, 7, 7, 7, 0, 7, 0, 7, 7, 7, 0, 7];
const ubyte[25] TIMEZONE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 8, 7, 8, 0, 8, 8, 8, 0, 8];
const ubyte[25] NETSPEED_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 11,0, 11,8, 11, 0, 11, 0, 11, 0, 11];
const ubyte[25] IDDCODE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 12, 0, 12, 0, 12, 9, 12, 0, 12];
const ubyte[25] AREACODE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10 ,13 ,0, 13, 0, 13, 10, 13, 0, 13];
const ubyte[25] WEATHERSTATIONCODE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 14, 0, 14, 0, 14, 0, 14];
const ubyte[25] WEATHERSTATIONNAME_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 15, 0, 15, 0, 15, 0, 15];
const ubyte[25] MCC_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 16, 0, 16, 9, 16];
const ubyte[25] MNC_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10,17, 0, 17, 10, 17];
const ubyte[25] MOBILEBRAND_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11,18, 0, 18, 11, 18];
const ubyte[25] ELEVATION_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 19, 0, 19];
const ubyte[25] USAGETYPE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 20];

protected const string API_VERSION = "8.0.3";

protected const BigInt MAX_IPV4_RANGE = BigInt("4294967295");

version(X86)
{
	protected const BigInt MAX_IPV6_RANGE;

	static this()
	{
		MAX_IPV6_RANGE = BigInt("340282366920938463463374607431768211455");
	}
}
else protected const BigInt MAX_IPV6_RANGE = BigInt("340282366920938463463374607431768211455");

protected const uint COUNTRYSHORT = 0x00001;
protected const uint COUNTRYLONG = 0x00002;
protected const uint REGION = 0x00004;
protected const uint CITY = 0x00008;
protected const uint ISP = 0x00010;
protected const uint LATITUDE = 0x00020;
protected const uint LONGITUDE = 0x00040;
protected const uint DOMAIN = 0x00080;
protected const uint ZIPCODE = 0x00100;
protected const uint TIMEZONE = 0x00200;
protected const uint NETSPEED = 0x00400;
protected const uint IDDCODE = 0x00800;
protected const uint AREACODE = 0x01000;
protected const uint WEATHERSTATIONCODE = 0x02000;
protected const uint WEATHERSTATIONNAME = 0x04000;
protected const uint MCC = 0x08000;
protected const uint MNC = 0x10000;
protected const uint MOBILEBRAND = 0x20000;
protected const uint ELEVATION = 0x40000;
protected const uint USAGETYPE = 0x80000;

protected const uint ALL = COUNTRYSHORT | COUNTRYLONG | REGION | CITY | ISP | LATITUDE | LONGITUDE | DOMAIN | ZIPCODE | TIMEZONE | NETSPEED | IDDCODE | AREACODE | WEATHERSTATIONCODE | WEATHERSTATIONNAME | MCC | MNC | MOBILEBRAND | ELEVATION | USAGETYPE;

protected const string INVALID_ADDRESS = "Invalid IP address.";
protected const string MISSING_FILE = "Invalid database file.";
protected const string NOT_SUPPORTED = "This parameter is unavailable for selected data file. Please upgrade the data file.";

class ip2location {
	protected MmFile db;
	private string binfile = "";
	private ip2locationmeta meta;
	private bool metaok = false;
	
	private uint country_position_offset;
	private uint region_position_offset;
	private uint city_position_offset;
	private uint isp_position_offset;
	private uint domain_position_offset;
	private uint zipcode_position_offset;
	private uint latitude_position_offset;
	private uint longitude_position_offset;
	private uint timezone_position_offset;
	private uint netspeed_position_offset;
	private uint iddcode_position_offset;
	private uint areacode_position_offset;
	private uint weatherstationcode_position_offset;
	private uint weatherstationname_position_offset;
	private uint mcc_position_offset;
	private uint mnc_position_offset;
	private uint mobilebrand_position_offset;
	private uint elevation_position_offset;
	private uint usagetype_position_offset;
	
	private bool country_enabled;
	private bool region_enabled;
	private bool city_enabled;
	private bool isp_enabled;
	private bool domain_enabled;
	private bool zipcode_enabled;
	private bool latitude_enabled;
	private bool longitude_enabled;
	private bool timezone_enabled;
	private bool netspeed_enabled;
	private bool iddcode_enabled;
	private bool areacode_enabled;
	private bool weatherstationcode_enabled;
	private bool weatherstationname_enabled;
	private bool mcc_enabled;
	private bool mnc_enabled;
	private bool mobilebrand_enabled;
	private bool elevation_enabled;
	private bool usagetype_enabled;
	
	// constructor
	public this(const string binpath) {
		binfile = binpath;
		
		readmeta();
	}
	
	// get version of API
	public string api_version() {
		return API_VERSION;
	}
	
	// read string
	private string readstr(uint index) {
		uint pos = index + 1;
		ubyte len = cast(ubyte)db[index]; // get length of string
		char[] stuff = cast(char[])db[pos .. (pos + len)];
		return to!string(stuff);
	}
	
	// read unsigned 32-bit integer
	private uint readuint(uint index) {
		uint pos = index - 1;
		uint result = 0;
		for (int x = 0; x < 4; x++) {
			uint tiny = cast(ubyte)db[pos + x];
			result += (tiny << (8 * x));
		}
		return result;
	}
	
	// read unsigned 128-bit integer
	private BigInt readuint128(uint index) {
		uint pos = index - 1;
		BigInt result = BigInt("0");
		
		for (int x = 0; x < 16; x++) {
			BigInt biggie = cast(ubyte)db[pos + x];
			result += (biggie << (8 * x));
		}
		
		return result;
	}
	
	// read float
	private float readfloat(uint index) {
		uint pos = index - 1;
		ubyte[4] fl;
		float result = 0.0;
		for (int x = 0; x < 4; x++) {
			fl[x] = cast(ubyte)db[pos + x];
		}
		
		result = littleEndianToNative!float(fl);
		return result;
	}
	
	// read BIN file metadata
	private void readmeta() {
		if (binfile.length == 0) {
			writeln("BIN file path cannot be blank.");
			return;
		}
		else if (!exists(binfile)) {
			writeln("BIN file does not exists.");
			return;
		}
		db = new MmFile(binfile);
		
		meta.databasetype = db[0];
		meta.databasecolumn = db[1];
		meta.databaseyear = db[2];
		meta.databasemonth = db[3];
		meta.databaseday = db[4];
		meta.ipv4databasecount =  readuint(6);
		meta.ipv4databaseaddr =  readuint(10);
		meta.ipv6databasecount =  readuint(14);
		meta.ipv6databaseaddr =  readuint(18);
		meta.ipv4indexbaseaddr =  readuint(22);
		meta.ipv6indexbaseaddr =  readuint(26);
		meta.ipv4columnsize = meta.databasecolumn << 2; // 4 bytes each column
		meta.ipv6columnsize = 16 + ((meta.databasecolumn - 1) << 2); // 4 bytes each column, except IPFrom column which is 16 bytes
		
		uint dbt = meta.databasetype;
		
		// since both IPv4 and IPv6 use 4 bytes for the below columns, can just do it once here
		country_position_offset = (COUNTRY_POSITION[dbt] != 0) ? (COUNTRY_POSITION[dbt] - 1) << 2 : 0;
		region_position_offset = (REGION_POSITION[dbt] != 0) ? (REGION_POSITION[dbt] - 1) << 2 : 0;
		city_position_offset = (CITY_POSITION[dbt] != 0) ? (CITY_POSITION[dbt] - 1) << 2 : 0;
		isp_position_offset = (ISP_POSITION[dbt] != 0) ? (ISP_POSITION[dbt] - 1) << 2 : 0;
		domain_position_offset = (DOMAIN_POSITION[dbt] != 0) ? (DOMAIN_POSITION[dbt] - 1) << 2 : 0;
		zipcode_position_offset = (ZIPCODE_POSITION[dbt] != 0) ? (ZIPCODE_POSITION[dbt] - 1) << 2 : 0;
		latitude_position_offset = (LATITUDE_POSITION[dbt] != 0) ? (LATITUDE_POSITION[dbt] - 1) << 2 : 0;
		longitude_position_offset = (LONGITUDE_POSITION[dbt] != 0) ? (LONGITUDE_POSITION[dbt] - 1) << 2 : 0;
		timezone_position_offset = (TIMEZONE_POSITION[dbt] != 0) ? (TIMEZONE_POSITION[dbt] - 1) << 2 : 0;
		netspeed_position_offset = (NETSPEED_POSITION[dbt] != 0) ? (NETSPEED_POSITION[dbt] - 1) << 2 : 0;
		iddcode_position_offset = (IDDCODE_POSITION[dbt] != 0) ? (IDDCODE_POSITION[dbt] - 1) << 2 : 0;
		areacode_position_offset = (AREACODE_POSITION[dbt] != 0) ? (AREACODE_POSITION[dbt] - 1) << 2 : 0;
		weatherstationcode_position_offset = (WEATHERSTATIONCODE_POSITION[dbt] != 0) ? (WEATHERSTATIONCODE_POSITION[dbt] - 1) << 2 : 0;
		weatherstationname_position_offset = (WEATHERSTATIONNAME_POSITION[dbt] != 0) ? (WEATHERSTATIONNAME_POSITION[dbt] - 1) << 2 : 0;
		mcc_position_offset = (MCC_POSITION[dbt] != 0) ? (MCC_POSITION[dbt] - 1) << 2 : 0;
		mnc_position_offset = (MNC_POSITION[dbt] != 0) ? (MNC_POSITION[dbt] - 1) << 2 : 0;
		mobilebrand_position_offset = (MOBILEBRAND_POSITION[dbt] != 0) ? (MOBILEBRAND_POSITION[dbt] - 1) << 2 : 0;
		elevation_position_offset = (ELEVATION_POSITION[dbt] != 0) ? (ELEVATION_POSITION[dbt] - 1) << 2 : 0;
		usagetype_position_offset = (USAGETYPE_POSITION[dbt] != 0) ? (USAGETYPE_POSITION[dbt] - 1) << 2 : 0;

		country_enabled = (COUNTRY_POSITION[dbt] != 0) ? true : false;
		region_enabled = (REGION_POSITION[dbt] != 0) ? true : false;
		city_enabled = (CITY_POSITION[dbt] != 0) ? true : false;
		isp_enabled = (ISP_POSITION[dbt] != 0) ? true : false;
		latitude_enabled = (LATITUDE_POSITION[dbt] != 0) ? true : false;
		longitude_enabled = (LONGITUDE_POSITION[dbt] != 0) ? true : false;
		domain_enabled = (DOMAIN_POSITION[dbt] != 0) ? true : false;
		zipcode_enabled = (ZIPCODE_POSITION[dbt] != 0) ? true : false;
		timezone_enabled = (TIMEZONE_POSITION[dbt] != 0) ? true : false;
		netspeed_enabled = (NETSPEED_POSITION[dbt] != 0) ? true : false;
		iddcode_enabled = (IDDCODE_POSITION[dbt] != 0) ? true : false;
		areacode_enabled = (AREACODE_POSITION[dbt] != 0) ? true : false;
		weatherstationcode_enabled = (WEATHERSTATIONCODE_POSITION[dbt] != 0) ? true : false;
		weatherstationname_enabled = (WEATHERSTATIONNAME_POSITION[dbt] != 0) ? true : false;
		mcc_enabled = (MCC_POSITION[dbt] != 0) ? true : false;
		mnc_enabled = (MNC_POSITION[dbt] != 0) ? true : false;
		mobilebrand_enabled = (MOBILEBRAND_POSITION[dbt] != 0) ? true : false;
		elevation_enabled = (ELEVATION_POSITION[dbt] != 0) ? true : false;
		usagetype_enabled = (USAGETYPE_POSITION[dbt] != 0) ? true : false;
		
		metaok = true;
	}
	
	// determine IP type
	private ipv checkip(const string ipaddress) {
		ipv ipdata;
		const char[] ip = ipaddress;
		try {
			auto results = getAddressInfo(ipaddress, AddressInfoFlags.NUMERICHOST);
			
			if (results.length && results[0].family == AddressFamily.INET) {
				ipdata.iptype = 4;
				uint ipno = new InternetAddress(ip, 80).addr();
				ipdata.ipnum = ipno;
				if (meta.ipv4indexbaseaddr > 0) {
					ipdata.ipindex = ((ipno >> 16) << 3) + meta.ipv4indexbaseaddr;
				}
			}
			else if (results.length && results[0].family == AddressFamily.INET6) {
				ipdata.iptype = 6;
				ubyte[16] ipno = new Internet6Address(ip, 80).addr();
				for (int x = 15, y = 0; x >= 0; x--, y++) {
					BigInt biggie = ipno[x];
					ipdata.ipnum += (biggie << (8 * y));
				}
				if (meta.ipv6indexbaseaddr > 0) {
					ipdata.ipindex = (((ipno[0] << 8) + ipno[1]) << 3) + meta.ipv6indexbaseaddr;
				}
				
				// check special case where IPv4 address in IPv6 format (::ffff:0.0.0.0 or ::ffff:00:00)
				if (ipno[0] == 0 && ipno[1] == 0 && ipno[2] == 0 && ipno[3] == 0 && ipno[4] == 0 && ipno[5] == 0 && ipno[6] == 0 && ipno[7] == 0 && ipno[8] == 0 && ipno[9] == 0 && ipno[10] == 255 && ipno[11] == 255) {
					ipdata.iptype = 4;
					uint ipno2 = (ipno[12] << 24) + (ipno[13] << 16) + (ipno[14] << 8) + ipno[15];
					ipdata.ipnum = ipno2;
					if (meta.ipv4indexbaseaddr > 0) {
						ipdata.ipindex = ((ipno2 >> 16) << 3) + meta.ipv4indexbaseaddr;
					}
				}
			}
		}
		catch (Exception e) {
			ipdata.iptype = 0;
		}
		return ipdata;
	}
	
	// populate record with message
	private ip2locationrecord loadmessage(const string mesg) {
		ip2locationrecord x;
		
		foreach (i, ref part; x.tupleof) {
			static if (is(typeof(part) == string)) {
				part = mesg;
			}
		}
		return x;
	}
	
	// for debugging purposes
	public void printrecord(ip2locationrecord x) {
		foreach (i, ref part; x.tupleof) {
			static if (is(typeof(part) == string)) {
				writefln("%s: %s", __traits(identifier, x.tupleof[i]), part);
			}
			else {
				writefln("%s: %f", __traits(identifier, x.tupleof[i]), part);
			}
		}
	}
	
	// get all fields
	public ip2locationrecord get_all(const string ipaddress) {
		return query(ipaddress, ALL);
	}
	
	// get country code
	public ip2locationrecord get_country_short(const string ipaddress) {
		return query(ipaddress, COUNTRYSHORT);
	}
	
	// get country name
	public ip2locationrecord get_country_long(const string ipaddress) {
		return query(ipaddress, COUNTRYLONG);
	}
	
	// get region
	public ip2locationrecord get_region(const string ipaddress) {
		return query(ipaddress, REGION);
	}
	
	// get city
	public ip2locationrecord get_city(const string ipaddress) {
		return query(ipaddress, CITY);
	}
	
	// get ISP
	public ip2locationrecord get_isp(const string ipaddress) {
		return query(ipaddress, ISP);
	}
	
	// get latitude
	public ip2locationrecord get_latitude(const string ipaddress) {
		return query(ipaddress, LATITUDE);
	}
	
	// get longitude
	public ip2locationrecord get_longitude(const string ipaddress) {
		return query(ipaddress, LONGITUDE);
	}
	
	// get domain
	public ip2locationrecord get_domain(const string ipaddress) {
		return query(ipaddress, DOMAIN);
	}
	
	// get ZIP code
	public ip2locationrecord get_zipcode(const string ipaddress) {
		return query(ipaddress, ZIPCODE);
	}
	
	// get time zone
	public ip2locationrecord get_timezone(const string ipaddress) {
		return query(ipaddress, TIMEZONE);
	}
	
	// get net speed
	public ip2locationrecord get_netspeed(const string ipaddress) {
		return query(ipaddress, NETSPEED);
	}
	
	// get IDD code
	public ip2locationrecord get_iddcode(const string ipaddress) {
		return query(ipaddress, IDDCODE);
	}
	
	// get area code
	public ip2locationrecord get_areacode(const string ipaddress) {
		return query(ipaddress, AREACODE);
	}
	
	// get weather station code
	public ip2locationrecord get_weatherstationcode(const string ipaddress) {
		return query(ipaddress, WEATHERSTATIONCODE);
	}
	
	// get weather station name
	public ip2locationrecord get_weatherstationname(const string ipaddress) {
		return query(ipaddress, WEATHERSTATIONNAME);
	}
	
	// get mobile country code
	public ip2locationrecord get_mcc(const string ipaddress) {
		return query(ipaddress, MCC);
	}
	
	// get mobile network code
	public ip2locationrecord get_mnc(const string ipaddress) {
		return query(ipaddress, MNC);
	}
	
	// get mobile carrier brand
	public ip2locationrecord get_mobilebrand(const string ipaddress) {
		return query(ipaddress, MOBILEBRAND);
	}
	
	// get elevation
	public ip2locationrecord get_elevation(const string ipaddress) {
		return query(ipaddress, ELEVATION);
	}
	
	// get usage type
	public ip2locationrecord get_usagetype(const string ipaddress) {
		return query(ipaddress, USAGETYPE);
	}
	
	// main query
	private ip2locationrecord query(const string ipaddress, uint mode) {
		auto x = loadmessage(NOT_SUPPORTED); // default message
		
		// read metadata
		if (!metaok) {
			x = loadmessage(MISSING_FILE);
			return x;
		}
		
		// check IP type and return IP number & index (if exists)
		auto ipdata = checkip(ipaddress);
		
		if (ipdata.iptype == 0) {
			x = loadmessage(INVALID_ADDRESS);
			return x;
		}
		
		uint colsize = 0;
		uint baseaddr = 0;
		uint low = 0;
		uint high = 0;
		uint mid = 0;
		uint rowoffset = 0;
		uint rowoffset2 = 0;
		BigInt ipno = ipdata.ipnum;
		BigInt ipfrom;
		BigInt ipto;
		BigInt maxip;
		
		if (ipdata.iptype == 4) {
			baseaddr = meta.ipv4databaseaddr;
			high = meta.ipv4databasecount;
			maxip = MAX_IPV4_RANGE;
			colsize = meta.ipv4columnsize;
		}
		else {
			baseaddr = meta.ipv6databaseaddr;
			high = meta.ipv6databasecount;
			maxip = MAX_IPV6_RANGE;
			colsize = meta.ipv6columnsize;
		}
		
		// reading index
		if (ipdata.ipindex > 0) {
			low = readuint(ipdata.ipindex);
			high = readuint(ipdata.ipindex + 4);
		}
		
		if (ipno >= maxip) {
			ipno = ipno - 1;
		}
		
		while (low <= high) {
			mid = ((low + high) >> 1);
			rowoffset = baseaddr + (mid * colsize);
			rowoffset2 = rowoffset + colsize;
			
			if (ipdata.iptype == 4) {
				ipfrom = readuint(rowoffset);
				ipto = readuint(rowoffset2);
			}
			else {
				ipfrom = readuint128(rowoffset);
				ipto = readuint128(rowoffset2);
			}
			
			if ((ipno >= ipfrom) && (ipno < ipto)) {
				if (ipdata.iptype == 6) {
					rowoffset = rowoffset + 12; // coz below is assuming all columns are 4 bytes, so got 12 left to go to make 16 bytes total
				}
				
				if ((mode & COUNTRYSHORT) && (country_enabled)) {
					x.country_short = readstr(readuint(rowoffset + country_position_offset));
				}
				
				if ((mode & COUNTRYLONG) && (country_enabled)) {
					x.country_long = readstr(readuint(rowoffset + country_position_offset) + 3);
				}
				
				if ((mode & REGION) && (region_enabled)) {
					x.region = readstr(readuint(rowoffset + region_position_offset));
				}
				
				if ((mode & CITY) && (city_enabled)) {
					x.city = readstr(readuint(rowoffset + city_position_offset));
				}
				
				if ((mode & ISP) && (isp_enabled)) {
					x.isp = readstr(readuint(rowoffset + isp_position_offset));
				}
				
				if ((mode & LATITUDE) && (latitude_enabled)) {
					x.latitude = readfloat(rowoffset + latitude_position_offset);
				}
				
				if ((mode & LONGITUDE) && (longitude_enabled)) {
					x.longitude = readfloat(rowoffset + longitude_position_offset);
				}
				
				if ((mode & DOMAIN) && (domain_enabled)) {
					x.domain = readstr(readuint(rowoffset + domain_position_offset));
				}
				
				if ((mode & ZIPCODE) && (zipcode_enabled)) {
					x.zipcode = readstr(readuint(rowoffset + zipcode_position_offset));
				}
				
				if ((mode & TIMEZONE) && (timezone_enabled)) {
					x.timezone = readstr(readuint(rowoffset + timezone_position_offset));
				}
				
				if ((mode & NETSPEED) && (netspeed_enabled)) {
					x.netspeed = readstr(readuint(rowoffset + netspeed_position_offset));
				}
				
				if ((mode & IDDCODE) && (iddcode_enabled)) {
					x.iddcode = readstr(readuint(rowoffset + iddcode_position_offset));
				}
				
				if ((mode & AREACODE) && (areacode_enabled)) {
					x.areacode = readstr(readuint(rowoffset + areacode_position_offset));
				}
				
				if ((mode & WEATHERSTATIONCODE) && (weatherstationcode_enabled)) {
					x.weatherstationcode = readstr(readuint(rowoffset + weatherstationcode_position_offset));
				}
				
				if ((mode & WEATHERSTATIONNAME) && (weatherstationname_enabled)) {
					x.weatherstationname = readstr(readuint(rowoffset + weatherstationname_position_offset));
				}
				
				if ((mode & MCC) && (mcc_enabled)) {
					x.mcc = readstr(readuint(rowoffset + mcc_position_offset));
				}
				
				if ((mode & MNC) && (mnc_enabled)) {
					x.mnc = readstr(readuint(rowoffset + mnc_position_offset));
				}
				
				if ((mode & MOBILEBRAND) && (mobilebrand_enabled)) {
					x.mobilebrand = readstr(readuint(rowoffset + mobilebrand_position_offset));
				}
				
				if ((mode & ELEVATION) && (elevation_enabled)) {
					x.elevation = to!float(readstr(readuint(rowoffset + elevation_position_offset)));
				}
				
				if ((mode & USAGETYPE) && (usagetype_enabled)) {
					x.usagetype = readstr(readuint(rowoffset + usagetype_position_offset));
				}
				
				return x;
			}
			else {
				if (ipno < ipfrom) {
					high = mid - 1;
				}
				else {
					low = mid + 1;
				}
			}
		}
		
		return x;
	}
}
