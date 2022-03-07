#!/bin/bash
sudo su -
s3_bucket="upgrad-bhargav"
myname="bhargav"
apt-get update -y 1>/dev/null

check=$(apt list apache2 2>/dev/null | grep 'installed' | wc -l)
if [ $check -eq 0 ]
then
	apt-get install apache2 -y
fi
check=$(apt list awscli 2>/dev/null | grep 'installed' | wc -l)
if [ $check -eq 0 ]
then
	apt-get install awscli -y
fi
apac=$(ls -l /var/run/apache2 | wc -l)
if [ $apac -eq 0 ]
then
	apache2 -k start
	sudo update-rc.d apache2 defaults
fi
tstamp=$(date "+%d%m%Y-%H%M%S")
cd /var/log/apache2
tar -cf $myname-httpd-logs-$tstamp.tar *
cp $myname-httpd-logs-$tstamp.tar /tmp
rm -f $myname-httpd-logs-$tstamp.tar
aws s3 cp /tmp/$myname-httpd-logs-$tstamp.tar s3://$s3_bucket/ 1>/dev/null
echo "Operation Completed"

