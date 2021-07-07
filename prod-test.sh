#!/bin/bash

STATUS=$(curl -s -o /dev/null --head -w "%{http_code}" -X GET "https://nicoles.duckdns.org/")

if [[ $STATUS == "200" ]]; then
    exit 0
else
    exit 1
fi