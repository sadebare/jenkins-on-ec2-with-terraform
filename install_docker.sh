#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
