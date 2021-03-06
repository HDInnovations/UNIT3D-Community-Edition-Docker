#!/bin/bash
hostnameValid=false
emailValid=false
hostname=""
email=""

if test -f Caddyfile && test -f env; then
  echo "Existing configs exist, skipping creation"
  echo "Run ./configure_docker.sh to regenerate your configs"
  exit 0
fi

if [ "$1" != "" ]; then
  hostnameValid=true
  hostname=$1
fi

if [ "$2" != "" ]; then
  emailValid=true
  email=$2
fi

while [ $hostnameValid == false ]; do
  read -rp "Enter your hostname (eg: example.com): " hostname
  echo "Using hostname for generated configs: $hostname"
  read -rp "Is this correct? [Y/n]" correct
  if [ "$correct" == "" ] || [ "$correct" == "y" ] || [ "$correct" == "Y" ]; then
    hostnameValid=true
  fi
done

while [ $emailValid == false ]; do
  read -rp "Enter your email for Lets Encrypt SSL Certs (eg: user@host.com): " email
  echo "Using email for registration: $email"
  read -rp "Is this correct? [Y/n]" correctE
  if [ "$correctE" == "" ] || [ "$correctE" == "y" ] || [ "$correctE" == "Y" ]; then
    emailValid=true
  fi
done

cp template/.env.example env
sed -i -r "s/APP_URL=$/APP_URL=https:\/\/${hostname}/g" env
sed -i -r "s/APP_HOSTNAME=$/APP_HOSTNAME=${hostname}/g" env
sed -i -r "s/LARAVEL_ECHO_SERVER_AUTH_HOST=$/LARAVEL_ECHO_SERVER_AUTH_HOST=https:\/\/${hostname}/g" env
echo "Createdenv"

cp template/Caddyfile Caddyfile
sed -i -r "s/APP_HOSTNAME/${hostname}/g" Caddyfile
sed -i -r "s/APP_EMAIL/${email}/g" Caddyfile
echo "Created Caddyfile"

# cp template/mika.yaml mika.yaml
#echo "Enter your IP2Location API Key if you have one. Without this you will not be " \
#  "able to use any geo lookup functionality."
#read -rp ": " geoenable
#if [ "$geoenable" != "" ]; then
#  echo "Enabling geo database functionality using key: $geoenable"
#  sed -i -r "s/geodb_api_key:/geodb_api_key: ${geoenable}/g" docker/mika.yaml
#  sed -i -r "s/geodb_enabled: false/geodb_enabled: true/g" docker/mika.yaml
#fi

# echo "Created docker/mika.yaml"