curl -s https://play.google.com/store/apps/details\?id\=$1 | grep "\"name\"\:" | awk -F "\"name\"\:\"" '{print $2}' |awk -F "\",\"url\"\:\"" '{print $1" ("$2}' | awk -F "\?" '{print $1")"}'
