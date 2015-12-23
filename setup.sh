#!/bin/sh

apt-get -y update
apt-get -y upgrade
cd /home/pi
mkdir -p shell/Python shell/log
git clone https://github.com/DexterInd/GrovePi.git
cd /home/pi/shell
cp -pfr /home/pi/GrovePi/Software/Python/ .
pip install awscli

cd /home/pi
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

apt-get -y install chkconfig
apt-get -y install i2c-tools python-smbus

cat >> /etc/modules <<EOF
i2c-bcm2708 
EOF

cat >> /boot/config.txt <<EOF
dtparam=i2c_arm=on
EOF

cd /root
git clone https://github.com/2015-GlobalPBL/pi_root.git
cp -Rp ./pi_root/* /

update-rc.d sensor01_02.sh defaults
update-rc.d sensor03.sh defaults
update-rc.d sensor04.sh defaults

cat >> cron << EOF
*/1 * * * * /home/pi/shell/Python/FileUpload_01.py > /dev/null 2>&1
*/1 * * * * /home/pi/shell/Python/FileUpload_02.py > /dev/null 2>&1
*/1 * * * * /home/pi/shell/Python/FileUpload_03.py > /dev/null 2>&1
*/1 * * * * /home/pi/shell/Python/FileUpload_04.py > /dev/null 2>&1
EOF

crontab cron
