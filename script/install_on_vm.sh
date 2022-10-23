#!/bin/bash
apt update && apt upgrade -y
apt install libpng-dev build-essential -y
curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list 
apt update && apt install yarn -y
node -v && npm -v && yarn -v
adduser --shell /bin/bash --disabled-login --gecos "" --quiet strapi
mkdir /srv/strapi
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu bionic main'
apt update && apt install mariadb-server-10.4 -y
mysql -u root -e "create database strapi_dev;"
mysql -u root -e "create user strapi@localhost identified by 'mysecurepassword';"
mysql -u root -e "grant all privileges on strapi_dev.* to strapi@localhost;"
mysql -u root -e "FLUSH PRIVILEGES;"
chown -R strapi:strapi /srv/strapi
sudo su - strapi
cd /srv/strapi/
yarn create strapi-app blog --quickstart --no-run
cd /srv/strapi/blog/
rm -rf config/database.js
cat << EOF > config/database.js 
module.exports = { apps: [ { name: 'strapi-dev', cwd: '/srv/strapi/blog', script: 'npm', args: 'start', env: { NODE_ENV: 'development', DB_HOST: 'localhost', DB_PORT: '3306', DB_NAME: 'strapi_dev', DB_USER: 'strapi', DB_PASS: 'mysecurepassword', JWT_SECRET: 'aSecretKey', }, }, ], }; 
EOF
npm install mysql
npm run build
yarn global add pm2
echo 'export PATH="$PATH:$(yarn global bin)"' >> ~/.bashrc
source ~/.bashrc
pm2 init
rm ecosystem.config.js
wget https://raw.githubusercontent.com/sangramrath/strapi.io/main/scripts/mysql/ecosystem.config.js
pm2 start ecosystem.config.js
pm2 startup systemd
exit
env PATH=$PATH:/usr/bin /home/strapi/.config/yarn/global/node_modules/pm2/bin/pm2 startup systemd -u strapi --hp /home/strapi
sudo su - strapi
pm2 save
