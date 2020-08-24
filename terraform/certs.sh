#!/bin/sh
openssl genrsa -out iot.pem 2048
openssl req -new -key iot.pem -out iot.csr
