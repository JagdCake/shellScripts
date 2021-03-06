#!/bin/bash

### Description ###
# Loop through an array of websites
# Print '[website] ONLINE / OFFLINE' for each one, depending on the response status code
### ###

### Usage ###
# You can just create an alias for the script in '.bashrc' and run it from a terminal
    # alias checkwebsites='/path/to/./check_websites.sh'
    # $ workspace
# You can create a symbolic link to the script from your home directory
    # ~$ ln -s /path/to/check_websites.sh
    # ~$ ./check_websites.sh
### ###

### Options ###
websites=(https://modeling.jagdcake.com/ https://request.jagdcake.com)
### ###

for i in ${websites[@]}
do
    status_code=$(curl -Is ${i} | head -n 1 | awk '{ print $2 }' )
    if [ $status_code -eq 200 ]
        then
            echo -e "${i} ONLINE"
        else
            echo -e "${i} OFFLINE"
    fi 2>/dev/null
done

