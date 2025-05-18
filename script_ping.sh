#!/bin/bash

  #set -e

  INTERVAL=1

  # Ask the user for the address and ...
  read -p "Enter the address to ping: " address
  read -p "Enter the maximum waiting time (in milliseconds) for a response: " max_time
  read -p "Enter the maximum number of failed ping: " max_failed
  # address=8.8.8.8; max_time=10; max_failed=3

  cnt=0
  while true
    do
      ping_result=$(ping -c 1 -W 1 "$address")
      result=$(echo $ping_result | tail -1)

      res=$(echo $result | awk -F ',' '{print $3}')
      if [[ "$res" = *"100.0% packet loss"* ]]; then
        ((cnt++))
        if [[ $cnt = 3 ]]; then
          echo "Failed: $max_failed unsuccessful ping $address"
          break
        fi
        continue
      fi
      cnt=0
      res=$(echo $result | awk -F '/' '{print $6}' | awk -F '.' '{print $1}')
      if [[ "$res" -gt "$max_time" ]]; then
        echo "Failed: ping $address time ($res ms) has exceeded $max_time ms"
        break
      fi
      sleep $INTERVAL
    done

echo "done"