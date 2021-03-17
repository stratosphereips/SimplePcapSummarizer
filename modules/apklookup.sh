# Author: Veronica Valeros <vero.valeros@gmail.com>
# Given an app ID, this script obtains an app name and URL from the Google Play Store
curl -s https://play.google.com/store/apps/details\?id\=$1 | grep "\"name\"\:" | awk -F "\"name\"\:\"" '{print $2}' |awk -F "\",\"url\"\:\"" '{print $1" ("$2}' | awk -F "\?" '{print $1")"}'
