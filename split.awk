#!/usr/local/bin/gawk -f
#

/LaunchPoint/ ||
/start/ ||
/end/ ||
/offerlocale/ ||
/SerialNumber/ 
{
	print $0;
}
