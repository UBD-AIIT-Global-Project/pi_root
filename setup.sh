#!/bin/sh

sudo su -
apt-get update
apt-get upgrade
cd /home/pi
mkdir -p shell/Python shell/logs
git clone https://github.com/DexterInd/GrovePi.git
pip install awscli

wget https://pypi.python.org/packages/source/s/simplejson/simplejson-3.8.1.tar.gz
tar -xvzf simplejson*.tar.gz
cd simplejson*
python setup.py install
cd ../

wget https://pypi.python.org/packages/source/r/requests/requests-2.9.0.tar.gz
tar -xvzf requests-2.9.0.tar.gz
cd requests-2.9.0
python setup.py install
cd ../

wget https://pypi.python.org/packages/source/r/requests-oauthlib/requests-oauthlib-0.6.0.tar.gz
tar -xvzf requests-oauthlib-0.6.0.tar.gz
cd requests-oauthlib-0.6.0
python setup.py install
cd ../
 
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-19.1.1.tar.gz
tar -xvzf setuptools-19.1.1.tar.gz
cd setuptools*
python setup.py install
cd ../

wget https://pypi.python.org/packages/source/o/oauthlib/oauthlib-1.0.3.tar.gz
tar -xvzf oauthlib-1.0.3.tar.gz
cd oauthlib-*
python setup.py install
cd ../

wget https://python-twitter.googlecode.com/files/python-twitter-1.1.tar.gz
tar -xvzf python-twitter-1.1.tar.gz
cd python-twitter-*
python setup.py install

apt-get install chkconfig

cd /root
git clone https://github.com/2015-GlobalPBL/pi_root.git
cp -Rp ./pi_root/* /

update-rc.d sensor01_02.sh defaults
update-rc.d sensor03.sh defaults
update-rc.d sensor04.sh defaults


cat >> cron << EOF
*/5 * * * * /home/pi/shell/Python/FileUpload_01.py > /dev/null 2>&1
*/5 * * * * /home/pi/shell/Python/FileUpload_02.py > /dev/null 2>&1
*/5 * * * * /home/pi/shell/Python/FileUpload_03.py > /dev/null 2>&1
*/5 * * * * /home/pi/shell/Python/FileUpload_04.py > /dev/null 2>&1
EOF

crontab cron
