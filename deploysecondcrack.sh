# Install Apache, PHP, Python, Git, and dependancies
rpm --import https://fedoraproject.org/static/0608B895.txt 
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

if [ $1 == "apache" ] then 
sudo yum install -y httpd inotify-tools php php-process python git gcc automake autoconf libtool make curl-devel libgcc.i686 glibc.i686 php-xml php-mbstring;
sudo chkconfig  httpd on;
else
sudo yum install -y nginx php-fpm inotify-tools php-cli php-mysql php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-magickwand php-magpierss php-mbstring php-mcrypt php-mssql php-shout php-snmp php-soap php-tidy php-process python git gcc automake autoconf libtool make curl-devel libgcc.i686 glibc.i686 php-xml php-mbstring;
echo 'date.timezone = "Europe/Berlin"' >> /etc/php.ini
chkconfig --levels 235 php-fpm on
/etc/init.d/php-fpm start
fi

# Install deploysecondcrack

sudo git clone git://github.com/nickwynja/deploysecondcrack.git;

# Install Dropbox
    
wget -O - http://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf -
sudo mkdir -p ~/Dropbox;
sudo chown -R blog ~/Dropbox;
sudo chmod -R u+rw ~/Dropbox;
sudo mkdir -p ~/.dropbox;
sudo chown -R blog ~/.dropbox;
sudo chmod -R u+rw ~/.dropbox;
sudo chmod -R o+x  ~/Dropbox;

# Install Dropbox service

sudo cp ~/deploysecondcrack/config-files/dropbox-service /etc/init.d/dropbox;
sudo cp ~/deploysecondcrack/config-files/sysconfig-dropbox /etc/sysconfig/dropbox;
sudo chmod 755 /etc/init.d/dropbox
sudo chkconfig --add dropbox;
sudo chkconfig dropbox on;

# Install Dropbox CLI

mkdir -p ~/bin;
sudo wget -O /usr/bin/dropbox "http://www.dropbox.com/download?dl=packages/dropbox.py";
sudo chmod 755 /usr/bin/dropbox;

# Set up Second Crack `update` cron
  
sudo crontab ~/deploysecondcrack/config-files/crontab.example;

# Config Apache with default settings
if [ $1 == "apache" ] then 
sudo cp ~/deploysecondcrack/config-files/httpd.conf /etc/httpd/conf/httpd.conf;
sudo rm /etc/httpd/conf.d/welcome.conf;
sudo chmod o+x ~;
service httpd restart
else
sudo cp ~/deploysecondcrack/config-files/nginx.conf /etc/nginx/sites-available/secondcrack.conf;
mkdir -p /home/blog/secondcrack/logs/
cd /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/secondcrack.conf
service nginx restart
fi

# Config PHP settings for short_open_tags

sudo cp ~/deploysecondcrack/config-files/php.ini /etc/php.ini;

# Install Second Crack

cd ~/ ;
git clone git://github.com/marcoarment/secondcrack.git;

# Configure Second Crack

sudo mkdir -p ~/Dropbox/Blog/templates/;
sudo cp ~/secondcrack/example-templates/main.php ~/Dropbox/Blog/templates/main.php;
sudo cp ~/secondcrack/example-templates/rss.php ~/Dropbox/Blog/templates/rss.php;
sudo mkdir -p ~/Dropbox/Blog/assets/css/;
sudo cp ~/deploysecondcrack/config-files/main.css ~/Dropbox/Blog/assets/css/main.css;
sudo mkdir -p ~/secondcrack/www/;
sudo ln -s ~/Dropbox/Blog/assets ~/secondcrack/www/assets;
sudo chmod -R o+x  ~/Dropbox;
sudo chown -R blog:blog ~/secondcrack/;
sudo chown -R blog:blog ~/Dropbox/;
sudo chown -R blog:blog ~/deploysecondcrack;
sudo cp ~/deploysecondcrack/config-files/config.php.example ~/secondcrack/config.php;
sudo vi ~/secondcrack/config.php;
