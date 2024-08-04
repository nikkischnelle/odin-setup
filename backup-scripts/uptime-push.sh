#!/bin/bash

# Check if ID argument is provided
if [ $# -ne 1 ]; then
	  echo "Usage: $0 <ID>"
	    exit 1
fi

curl "http://192.168.10.2:3001/api/push/$1?status=up&msg=OK&ping="
