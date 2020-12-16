#!/bin/bash
npm install
npm install cross-env
npm run production
cp -r ./public/favicon.ico ./public/index.php ./public/robots.txt ./public/web.config ./static/
cp -r ./public/css/ ./public/fonts/ ./public/img/ ./public/js/ ./public/sounds/ ./public/mix-manifest.json ./static/