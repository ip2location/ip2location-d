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
	bool ipv4indexed;
	bool ipv6indexed;
	uint ipv4indexbaseaddr;
	uint ipv6indexbaseaddr;
	uint ipv4columnsize;
	uint ipv6columnsize;
	ubyte productcode;
	ubyte producttype;
	uint filesize;
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
	string addresstype = "-";
	string category = "-";
	string district = "-";
	string asn = "-";
	string as = "-";
}

protected struct ipv {
	uint iptype = 0;
	BigInt ipnum = BigInt("0");
	uint ipindex = 0; 
}

const ubyte[27] COUNTRY_POSITION = [0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2];
const ubyte[27] REGION_POSITION = [0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3];
const ubyte[27] CITY_POSITION = [0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
const ubyte[27] ISP_POSITION = [0, 0, 3, 0, 5, 0, 7, 5, 7, 0, 8, 0, 9, 0, 9, 0, 9, 0, 9, 7, 9, 0, 9, 7, 9, 9, 9];
const ubyte[27] LATITUDE_POSITION = [0, 0, 0, 0, 0, 5, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
const ubyte[27] LONGITUDE_POSITION = [0, 0, 0, 0, 0, 6, 6, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6];
const ubyte[27] DOMAIN_POSITION = [0, 0, 0, 0, 0, 0, 0, 6, 8, 0, 9, 0, 10,0, 10, 0, 10, 0, 10, 8, 10, 0, 10, 8, 10, 10, 10];
const ubyte[27] ZIPCODE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7, 7, 0, 7, 7, 7, 0, 7, 0, 7, 7, 7, 0, 7, 7, 7];
const ubyte[27] TIMEZONE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 8, 7, 8, 0, 8, 8, 8, 0, 8, 8, 8];
const ubyte[27] NETSPEED_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 11,0, 11,8, 11, 0, 11, 0, 11, 0, 11, 11, 11];
const ubyte[27] IDDCODE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 12, 0, 12, 0, 12, 9, 12, 0, 12, 12, 12];
const ubyte[27] AREACODE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10 ,13 ,0, 13, 0, 13, 10, 13, 0, 13, 13, 13];
const ubyte[27] WEATHERSTATIONCODE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 14, 0, 14, 0, 14, 0, 14, 14, 14];
const ubyte[27] WEATHERSTATIONNAME_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 15, 0, 15, 0, 15, 0, 15, 15, 15];
const ubyte[27] MCC_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 16, 0, 16, 9, 16, 16, 16];
const ubyte[27] MNC_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10,17, 0, 17, 10, 17, 17, 17];
const ubyte[27] MOBILEBRAND_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11,18, 0, 18, 11, 18, 18, 18];
const ubyte[27] ELEVATION_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 19, 0, 19, 19, 19];
const ubyte[27] USAGETYPE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 20, 20, 20];
const ubyte[27] ADDRESSTYPE_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 21];
const ubyte[27] CATEGORY_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 22];
const ubyte[27] DISTRICT_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23];
const ubyte[27] ASN_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24];
const ubyte[27] AS_POSITION = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25];

protected const string API_VERSION = "8.7.0";

version(X86)
{
	// CTFE of BigInt only supported since phobos 2.079
	static if (__VERSION__ < 2079)
	{
		protected const BigInt MAX_IPV4_RANGE;
		protected const BigInt MAX_IPV6_RANGE;
		protected const BigInt FROM_6TO4;
		protected const BigInt TO_6TO4;
		protected const BigInt FROM_TEREDO;
		protected const BigInt TO_TEREDO;
		protected const BigInt LAST_32BITS;

		static this()
		{
			MAX_IPV4_RANGE = BigInt("4294967295");
			MAX_IPV6_RANGE = BigInt("340282366920938463463374607431768211455");
			FROM_6TO4 = BigInt("42545680458834377588178886921629466624");
			TO_6TO4 = BigInt("42550872755692912415807417417958686719");
			FROM_TEREDO = BigInt("42540488161975842760550356425300246528");
			TO_TEREDO = BigInt("42540488241204005274814694018844196863");
			LAST_32BITS = BigInt("4294967295");
		}
	}
	else {
		protected const MAX_IPV4_RANGE = BigInt("4294967295");
		protected const MAX_IPV6_RANGE = BigInt("340282366920938463463374607431768211455");
		protected const FROM_6TO4 = BigInt("42545680458834377588178886921629466624");
		protected const TO_6TO4 = BigInt("42550872755692912415807417417958686719");
		protected const FROM_TEREDO = BigInt("42540488161975842760550356425300246528");
		protected const TO_TEREDO = BigInt("42540488241204005274814694018844196863");
		protected const LAST_32BITS = BigInt("4294967295");
	}
}
else {
	protected const BigInt MAX_IPV4_RANGE = BigInt("4294967295");
	protected const BigInt MAX_IPV6_RANGE = BigInt("340282366920938463463374607431768211455");
	protected const BigInt FROM_6TO4 = BigInt("42545680458834377588178886921629466624");
	protected const BigInt TO_6TO4 = BigInt("42550872755692912415807417417958686719");
	protected const BigInt FROM_TEREDO = BigInt("42540488161975842760550356425300246528");
	protected const BigInt TO_TEREDO = BigInt("42540488241204005274814694018844196863");
	protected const BigInt LAST_32BITS = BigInt("4294967295");
}

protected const uint COUNTRYSHORT = 0x0000001;
protected const uint COUNTRYLONG = 0x0000002;
protected const uint REGION = 0x0000004;
protected const uint CITY = 0x0000008;
protected const uint ISP = 0x0000010;
protected const uint LATITUDE = 0x0000020;
protected const uint LONGITUDE = 0x0000040;
protected const uint DOMAIN = 0x0000080;
protected const uint ZIPCODE = 0x0000100;
protected const uint TIMEZONE = 0x0000200;
protected const uint NETSPEED = 0x0000400;
protected const uint IDDCODE = 0x0000800;
protected const uint AREACODE = 0x0001000;
protected const uint WEATHERSTATIONCODE = 0x0002000;
protected const uint WEATHERSTATIONNAME = 0x0004000;
protected const uint MCC = 0x0008000;
protected const uint MNC = 0x0010000;
protected const uint MOBILEBRAND = 0x0020000;
protected const uint ELEVATION = 0x0040000;
protected const uint USAGETYPE = 0x0080000;
protected const uint ADDRESSTYPE = 0x0100000;
protected const uint CATEGORY = 0x0200000;
protected const uint DISTRICT = 0x0400000;
protected const uint ASN = 0x0800000;
protected const uint AS = 0x1000000;

protected const uint ALL = COUNTRYSHORT | COUNTRYLONG | REGION | CITY | ISP | LATITUDE | LONGITUDE | DOMAIN | ZIPCODE | TIMEZONE | NETSPEED | IDDCODE | AREACODE | WEATHERSTATIONCODE | WEATHERSTATIONNAME | MCC | MNC | MOBILEBRAND | ELEVATION | USAGETYPE | ADDRESSTYPE | CATEGORY | DISTRICT | ASN | AS;

protected const string INVALID_ADDRESS = "Invalid IP address.";
protected const string MISSING_FILE = "Invalid database file.";
protected const string NOT_SUPPORTED = "This parameter is unavailable for selected data file. Please upgrade the data file.";
protected const string INVALID_BIN = "Incorrect IP2Location BIN file format. Please make sure that you are using the latest IP2Location BIN file.";

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
	private uint addresstype_position_offset;
	private uint category_position_offset;
	private uint district_position_offset;
	private uint asn_position_offset;
	private uint as_position_offset;
	
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
	private bool addresstype_enabled;
	private bool category_enabled;
	private bool district_enabled;
	private bool asn_enabled;
	private bool as_enabled;
	
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
		uint bytes = 256; // max size of string + 1 byte for length
		ubyte[] row = cast(ubyte[])db[index .. (index + bytes)];
		ubyte len = row[0]; // get length of string
		char[] stuff = cast(char[])row[1 .. (len + 1)];
		return to!string(stuff);
	}
	
	// read unsigned 32-bit integer from row
	private uint readuint_row(ref ubyte[] row, uint index) {
		ubyte[4] buf = row[index .. (index + 4)];
		uint result = 0;
		result = littleEndianToNative!uint(buf);
		return result;
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
	
	// read unsigned 128-bit integer from row
	private BigInt readuint128_row(ref ubyte[] row, uint index) {
		ubyte[16] buf = row[index .. (index + 16)];
		BigInt result = BigInt("0");
		
		for (int x = 0; x < 16; x++) {
			BigInt biggie = buf[x];
			result += (biggie << (8 * x));
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
	
	// read float from row
	private float readfloat_row(ref ubyte[] row, uint index) {
		ubyte[4] buf = row[index .. (index + 4)];
		float result = 0.0;
		result = littleEndianToNative!float(buf);
		return result;
	}
	
	// close connection and reset
	public void close() {
		binfile = "";
		db.destroy();
		meta.destroy();
		metaok = false;
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
		
		ubyte len = 64; // 64-byte header
		ubyte[] row = cast(ubyte[])db[0 .. len];
		
		meta.databasetype = row[0];
		meta.databasecolumn = row[1];
		meta.databaseyear = row[2];
		meta.databasemonth = row[3];
		meta.databaseday = row[4];
		meta.ipv4databasecount =  readuint_row(row, 5);
		meta.ipv4databaseaddr =  readuint_row(row, 9);
		meta.ipv6databasecount =  readuint_row(row, 13);
		meta.ipv6databaseaddr =  readuint_row(row, 17);
		meta.ipv4indexbaseaddr =  readuint_row(row, 21);
		meta.ipv6indexbaseaddr =  readuint_row(row, 25);
		meta.productcode = row[29];
		// below 2 fields just read for now, not being used yet
		meta.producttype = row[30];
		meta.filesize = readuint_row(row, 31);
		
		// check if is correct BIN (should be 1 for IP2Location BIN file), also checking for zipped file (PK being the first 2 chars)
		if ((meta.productcode != 1 && meta.databaseyear >= 21) || (meta.databasetype == 80 && meta.databasecolumn == 75)) { // only BINs from Jan 2021 onwards have this byte set
			throw new Exception(INVALID_BIN);
		}
		
		if (meta.ipv4indexbaseaddr > 0) {
			meta.ipv4indexed = true;
		}
		
		if (meta.ipv6databasecount > 0 && meta.ipv6indexbaseaddr > 0) {
			meta.ipv6indexed = true;
		}
		
		meta.ipv4columnsize = meta.databasecolumn << 2; // 4 bytes each column
		meta.ipv6columnsize = 16 + ((meta.databasecolumn - 1) << 2); // 4 bytes each column, except IPFrom column which is 16 bytes
		
		uint dbt = meta.databasetype;
		
		country_position_offset = (COUNTRY_POSITION[dbt] != 0) ? (COUNTRY_POSITION[dbt] - 2) << 2 : 0;
		region_position_offset = (REGION_POSITION[dbt] != 0) ? (REGION_POSITION[dbt] - 2) << 2 : 0;
		city_position_offset = (CITY_POSITION[dbt] != 0) ? (CITY_POSITION[dbt] - 2) << 2 : 0;
		isp_position_offset = (ISP_POSITION[dbt] != 0) ? (ISP_POSITION[dbt] - 2) << 2 : 0;
		domain_position_offset = (DOMAIN_POSITION[dbt] != 0) ? (DOMAIN_POSITION[dbt] - 2) << 2 : 0;
		zipcode_position_offset = (ZIPCODE_POSITION[dbt] != 0) ? (ZIPCODE_POSITION[dbt] - 2) << 2 : 0;
		latitude_position_offset = (LATITUDE_POSITION[dbt] != 0) ? (LATITUDE_POSITION[dbt] - 2) << 2 : 0;
		longitude_position_offset = (LONGITUDE_POSITION[dbt] != 0) ? (LONGITUDE_POSITION[dbt] - 2) << 2 : 0;
		timezone_position_offset = (TIMEZONE_POSITION[dbt] != 0) ? (TIMEZONE_POSITION[dbt] - 2) << 2 : 0;
		netspeed_position_offset = (NETSPEED_POSITION[dbt] != 0) ? (NETSPEED_POSITION[dbt] - 2) << 2 : 0;
		iddcode_position_offset = (IDDCODE_POSITION[dbt] != 0) ? (IDDCODE_POSITION[dbt] - 2) << 2 : 0;
		areacode_position_offset = (AREACODE_POSITION[dbt] != 0) ? (AREACODE_POSITION[dbt] - 2) << 2 : 0;
		weatherstationcode_position_offset = (WEATHERSTATIONCODE_POSITION[dbt] != 0) ? (WEATHERSTATIONCODE_POSITION[dbt] - 2) << 2 : 0;
		weatherstationname_position_offset = (WEATHERSTATIONNAME_POSITION[dbt] != 0) ? (WEATHERSTATIONNAME_POSITION[dbt] - 2) << 2 : 0;
		mcc_position_offset = (MCC_POSITION[dbt] != 0) ? (MCC_POSITION[dbt] - 2) << 2 : 0;
		mnc_position_offset = (MNC_POSITION[dbt] != 0) ? (MNC_POSITION[dbt] - 2) << 2 : 0;
		mobilebrand_position_offset = (MOBILEBRAND_POSITION[dbt] != 0) ? (MOBILEBRAND_POSITION[dbt] - 2) << 2 : 0;
		elevation_position_offset = (ELEVATION_POSITION[dbt] != 0) ? (ELEVATION_POSITION[dbt] - 2) << 2 : 0;
		usagetype_position_offset = (USAGETYPE_POSITION[dbt] != 0) ? (USAGETYPE_POSITION[dbt] - 2) << 2 : 0;
		addresstype_position_offset = (ADDRESSTYPE_POSITION[dbt] != 0) ? (ADDRESSTYPE_POSITION[dbt] - 2) << 2 : 0;
		category_position_offset = (CATEGORY_POSITION[dbt] != 0) ? (CATEGORY_POSITION[dbt] - 2) << 2 : 0;
		district_position_offset = (DISTRICT_POSITION[dbt] != 0) ? (DISTRICT_POSITION[dbt] - 2) << 2 : 0;
		asn_position_offset = (ASN_POSITION[dbt] != 0) ? (ASN_POSITION[dbt] - 2) << 2 : 0;
		as_position_offset = (AS_POSITION[dbt] != 0) ? (AS_POSITION[dbt] - 2) << 2 : 0;
		
		country_enabled = (COUNTRY_POSITION[dbt] != 0);
		region_enabled = (REGION_POSITION[dbt] != 0);
		city_enabled = (CITY_POSITION[dbt] != 0);
		isp_enabled = (ISP_POSITION[dbt] != 0);
		latitude_enabled = (LATITUDE_POSITION[dbt] != 0);
		longitude_enabled = (LONGITUDE_POSITION[dbt] != 0);
		domain_enabled = (DOMAIN_POSITION[dbt] != 0);
		zipcode_enabled = (ZIPCODE_POSITION[dbt] != 0);
		timezone_enabled = (TIMEZONE_POSITION[dbt] != 0);
		netspeed_enabled = (NETSPEED_POSITION[dbt] != 0);
		iddcode_enabled = (IDDCODE_POSITION[dbt] != 0);
		areacode_enabled = (AREACODE_POSITION[dbt] != 0);
		weatherstationcode_enabled = (WEATHERSTATIONCODE_POSITION[dbt] != 0);
		weatherstationname_enabled = (WEATHERSTATIONNAME_POSITION[dbt] != 0);
		mcc_enabled = (MCC_POSITION[dbt] != 0);
		mnc_enabled = (MNC_POSITION[dbt] != 0);
		mobilebrand_enabled = (MOBILEBRAND_POSITION[dbt] != 0);
		elevation_enabled = (ELEVATION_POSITION[dbt] != 0);
		usagetype_enabled = (USAGETYPE_POSITION[dbt] != 0);
		addresstype_enabled = (ADDRESSTYPE_POSITION[dbt] != 0);
		category_enabled = (CATEGORY_POSITION[dbt] != 0);
		district_enabled = (DISTRICT_POSITION[dbt] != 0);
		asn_enabled = (ASN_POSITION[dbt] != 0);
		as_enabled = (AS_POSITION[dbt] != 0);
		
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
				if (meta.ipv4indexed) {
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
				if (meta.ipv6indexed) {
					ipdata.ipindex = (((ipno[0] << 8) + ipno[1]) << 3) + meta.ipv6indexbaseaddr;
				}
				
				// check special case where IPv4 address in IPv6 format (::ffff:0.0.0.0 or ::ffff:00:00)
				if (ipno[0] == 0 && ipno[1] == 0 && ipno[2] == 0 && ipno[3] == 0 && ipno[4] == 0 && ipno[5] == 0 && ipno[6] == 0 && ipno[7] == 0 && ipno[8] == 0 && ipno[9] == 0 && ipno[10] == 255 && ipno[11] == 255) {
					ipdata.iptype = 4;
					uint ipno2 = (ipno[12] << 24) + (ipno[13] << 16) + (ipno[14] << 8) + ipno[15];
					ipdata.ipnum = ipno2;
					if (meta.ipv4indexed) {
						ipdata.ipindex = ((ipno2 >> 16) << 3) + meta.ipv4indexbaseaddr;
					}
				}
				else if (ipdata.ipnum >= FROM_6TO4 && ipdata.ipnum <= TO_6TO4) {
					// 6to4 so need to remap to ipv4
					ipdata.iptype = 4;
					ipdata.ipnum = ipdata.ipnum >> 80;
					ipdata.ipnum = ipdata.ipnum & LAST_32BITS;
					uint ipno2 = to!uint(ipdata.ipnum);
					if (meta.ipv4indexed) {
						ipdata.ipindex = ((ipno2 >> 16) << 3) + meta.ipv4indexbaseaddr;
					}
				}
				else if (ipdata.ipnum >= FROM_TEREDO && ipdata.ipnum <= TO_TEREDO) {
					// Teredo so need to remap to ipv4
					ipdata.iptype = 4;
					ipdata.ipnum = ~ipdata.ipnum; // bitwise NOT
					ipdata.ipnum = ipdata.ipnum & LAST_32BITS;
					uint ipno2 = to!uint(ipdata.ipnum);
					if (meta.ipv4indexed) {
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
	
	// for debugging purposes
	public void printmeta(ip2locationmeta x) {
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
	
	// get address type
	public ip2locationrecord get_addresstype(const string ipaddress) {
		return query(ipaddress, ADDRESSTYPE);
	}
	
	// get category
	public ip2locationrecord get_category(const string ipaddress) {
		return query(ipaddress, CATEGORY);
	}
	
	// get district
	public ip2locationrecord get_district(const string ipaddress) {
		return query(ipaddress, DISTRICT);
	}
	
	// get Autonomous System Number
	public ip2locationrecord get_asn(const string ipaddress) {
		return query(ipaddress, ASN);
	}
	
	// get Autonomous System
	public ip2locationrecord get_as(const string ipaddress) {
		return query(ipaddress, AS);
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
		uint start = 0;
		uint end = 0;
		ubyte[] row;
		ubyte[] fullrow;
		BigInt ipno = ipdata.ipnum;
		BigInt ipfrom;
		BigInt ipto;
		BigInt maxip;
		uint firstcol = 4; // 4 bytes for ip from
		
		if (ipdata.iptype == 4) {
			baseaddr = meta.ipv4databaseaddr;
			high = meta.ipv4databasecount;
			maxip = MAX_IPV4_RANGE;
			colsize = meta.ipv4columnsize;
		}
		else {
			firstcol = 16; // 16 bytes for ipv6
			baseaddr = meta.ipv6databaseaddr;
			high = meta.ipv6databasecount;
			maxip = MAX_IPV6_RANGE;
			colsize = meta.ipv6columnsize;
		}
		
		// reading index
		if (ipdata.ipindex > 0) {
			start = (ipdata.ipindex - 1);
			end = start + 8; // 4 bytes each for IP From and IP To
			row = cast(ubyte[])db[start .. end];
			low = readuint_row(row, 0);
			high = readuint_row(row, 4);
		}
		
		if (ipno >= maxip) {
			ipno = ipno - 1;
		}
		
		while (low <= high) {
			mid = ((low + high) >> 1);
			rowoffset = baseaddr + (mid * colsize);
			rowoffset2 = rowoffset + colsize;
			
			// reading IP From + whole row + next IP From
			start = (rowoffset - 1);
			end = start + colsize + firstcol;
			fullrow = cast(ubyte[])db[start .. end];
			
			if (ipdata.iptype == 4) {
				ipfrom = readuint_row(fullrow, 0);
				ipto = readuint_row(fullrow, colsize);
			}
			else {
				ipfrom = readuint128_row(fullrow, 0);
				ipto = readuint128_row(fullrow, colsize);
			}
			
			if ((ipno >= ipfrom) && (ipno < ipto)) {
				uint rowlen = colsize - firstcol;
				row = fullrow[firstcol .. (firstcol + rowlen)]; // extract the actual row data
				
				if ((mode & COUNTRYSHORT) && (country_enabled)) {
					x.country_short = readstr(readuint_row(row, country_position_offset));
				}
				
				if ((mode & COUNTRYLONG) && (country_enabled)) {
					x.country_long = readstr(readuint_row(row, country_position_offset) + 3);
				}
				
				if ((mode & REGION) && (region_enabled)) {
					x.region = readstr(readuint_row(row, region_position_offset));
				}
				
				if ((mode & CITY) && (city_enabled)) {
					x.city = readstr(readuint_row(row, city_position_offset));
				}
				
				if ((mode & ISP) && (isp_enabled)) {
					x.isp = readstr(readuint_row(row, isp_position_offset));
				}
				
				if ((mode & LATITUDE) && (latitude_enabled)) {
					x.latitude = readfloat_row(row, latitude_position_offset);
				}
				
				if ((mode & LONGITUDE) && (longitude_enabled)) {
					x.longitude = readfloat_row(row, longitude_position_offset);
				}
				
				if ((mode & DOMAIN) && (domain_enabled)) {
					x.domain = readstr(readuint_row(row, domain_position_offset));
				}
				
				if ((mode & ZIPCODE) && (zipcode_enabled)) {
					x.zipcode = readstr(readuint_row(row, zipcode_position_offset));
				}
				
				if ((mode & TIMEZONE) && (timezone_enabled)) {
					x.timezone = readstr(readuint_row(row, timezone_position_offset));
				}
				
				if ((mode & NETSPEED) && (netspeed_enabled)) {
					x.netspeed = readstr(readuint_row(row, netspeed_position_offset));
				}
				
				if ((mode & IDDCODE) && (iddcode_enabled)) {
					x.iddcode = readstr(readuint_row(row, iddcode_position_offset));
				}
				
				if ((mode & AREACODE) && (areacode_enabled)) {
					x.areacode = readstr(readuint_row(row, areacode_position_offset));
				}
				
				if ((mode & WEATHERSTATIONCODE) && (weatherstationcode_enabled)) {
					x.weatherstationcode = readstr(readuint_row(row, weatherstationcode_position_offset));
				}
				
				if ((mode & WEATHERSTATIONNAME) && (weatherstationname_enabled)) {
					x.weatherstationname = readstr(readuint_row(row, weatherstationname_position_offset));
				}
				
				if ((mode & MCC) && (mcc_enabled)) {
					x.mcc = readstr(readuint_row(row, mcc_position_offset));
				}
				
				if ((mode & MNC) && (mnc_enabled)) {
					x.mnc = readstr(readuint_row(row, mnc_position_offset));
				}
				
				if ((mode & MOBILEBRAND) && (mobilebrand_enabled)) {
					x.mobilebrand = readstr(readuint_row(row, mobilebrand_position_offset));
				}
				
				if ((mode & ELEVATION) && (elevation_enabled)) {
					x.elevation = to!float(readstr(readuint_row(row, elevation_position_offset)));
				}
				
				if ((mode & USAGETYPE) && (usagetype_enabled)) {
					x.usagetype = readstr(readuint_row(row, usagetype_position_offset));
				}
				
				if ((mode & ADDRESSTYPE) && (addresstype_enabled)) {
					x.addresstype = readstr(readuint_row(row, addresstype_position_offset));
				}
				
				if ((mode & CATEGORY) && (category_enabled)) {
					x.category = readstr(readuint_row(row, category_position_offset));
				}
				
				if ((mode & DISTRICT) && (district_enabled)) {
					x.district = readstr(readuint_row(row, district_position_offset));
				}
				
				if ((mode & ASN) && (asn_enabled)) {
					x.asn = readstr(readuint_row(row, asn_position_offset));
				}
				
				if ((mode & AS) && (as_enabled)) {
					x.as = readstr(readuint_row(row, as_position_offset));
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
