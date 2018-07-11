#!/bin/sh


# print HTTP header
# its best to print the header ASAP because 
# debugging is hard if an error stops a valid header being printed

echo Content-type: text/html
echo

# print page content

cat <<eof
<!DOCTYPE html>
<html lang="en">
<head>
<title>Browser IP, Host and User Agent</title>
</head>
<body>
eof
total=$(env)
ip=$(echo $total| egrep -o "REMOTE_ADDR=[0-9]+.[0-9]+.[0-9]+.[0-9]+"| sed "s/REMOTE_ADDR=//")
echo "Your browser is running at IP address: <b>$ip</b>"
echo "<p>"
total1=$(host $ip)
mhostname=$(echo $total1 | egrep -o "name pointer .*"|sed "s/name pointer //")
#mhostname=$(echo $mhostname | sed "s/.$//")
echo "Your browser is running on hostname: <b>$mhostname</b>"
echo "<p>"
total=$(env)
browser=$(echo $total| egrep -o "HTTP_USER_AGENT=.* REDIRECT_SCRIPT_URI"| sed "s/REDIRECT_SCRIPT_URI//"|sed "s/ SERVER_PORT=80 //")
echo "Your browser identifies as: <b>$browser</b>"
echo "<p>"
cat <<eof
</body>
</html>
eof
