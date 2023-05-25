#!/bin/bash
while read line
do
  echo "$line" | httpx -silent -fr -title -sc -cdn -td -random-agent -exclude-cdn
done < "${1:-/dev/stdin}"
