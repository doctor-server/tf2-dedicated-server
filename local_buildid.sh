#!/bin/sh
grep -oP '"buildid".{1,}"(.*?)"' /home/steam/serverfiles/steamapps/appmanifest_232250.acf | sed -n 's/.*"buildid".*"\(.*\)"/\1/p'
