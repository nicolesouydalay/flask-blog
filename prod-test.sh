#!/bin/bash

STATUS=$(curl -s -o /dev/null --head -w "%{http_code}" -X GET "https://nicoles.duckdns.org/")

if [[ $STATUS != "200" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null --head -w "%{http_code}" -X GET "nicoles.duckdns.org/health")

if [[ $STATUS != "200" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null --head -w "%{http_code}" -X GET "nicoles.duckdns.org/register")

if [[ $STATUS != "200" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null --head -w "%{http_code}" -X POST "nicoles.duckdns.org/register")

if [[ $STATUS != "418" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "username=bob" "nicoles.duckdns.org/register")

if [[ $STATUS != "418" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "password=12345" "nicoles.duckdns.org/register")

if [[ $STATUS != "418" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "username=bob&password=12345" "nicoles.duckdns.org/register")

if [[ $STATUS != "418" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null --head -w "%{http_code}" -X GET "nicoles.duckdns.org/login")

if [[ $STATUS != "200" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null --head -w "%{http_code}" -X POST "nicoles.duckdns.org/login")

if [[ $STATUS != "418" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "username=bob" "nicoles.duckdns.org/login")

if [[ $STATUS != "418" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "password=12345" "nicoles.duckdns.org/login")

if [[ $STATUS != "418" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "username=bob&password=5" "nicoles.duckdns.org/register")

if [[ $STATUS != "418" ]]; then
    exit 1
fi

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "username=bob&password=123" "nicoles.duckdns.org/login")

if [[ $STATUS != "200" ]]; then
    exit 1
fi

exit 0