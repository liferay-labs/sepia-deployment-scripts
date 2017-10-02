#!/usr/bin/env bash

curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -b ~/bin/aws
sudo pip3 install awsebcli --upgrade

aws --version
eb --version